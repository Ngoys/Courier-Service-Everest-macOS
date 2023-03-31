import Foundation

public class DeliveryViewModel: BaseViewModel {

    //----------------------------------------
    // MARK:- Initialization
    //----------------------------------------

    public init(couponStore: CouponStore, vehicleStore: VehicleStore) {
        self.couponStore = couponStore
        self.vehicleStore = vehicleStore
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    let weightChargedRate = 10.0

    let distanceChargedRate = 5.0

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    public func addPackage(text: String?) throws {
        // Split the text using a space " "
        // Remove whitespaces in each text
        // Remove empty item with empty string
        let items = text?.components(separatedBy: " ").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter{ $0.isEmpty == false } ?? []

        let id = items.first ?? ""
        var weightInKG: Double?
        var distanceInKM: Double?
        var offerCode: String?

        if id.isEmpty {
            throw AppError.invalidPackageID
        }

        if packages.contains(where: { $0.id == id }) {
            throw AppError.invalidPackageWithSameID
        }

        if items.indices.contains(1), let weightInKGParam = Double(items[1]) {
            weightInKG = weightInKGParam
        } else {
            throw AppError.invalidWeightInKG
        }

        if items.indices.contains(2), let distanceInKMParam = Double(items[2]) {
            distanceInKM = distanceInKMParam
        } else {
            throw AppError.invalidDistanceInKM
        }

        if items.indices.contains(3) {
            let offerCodeParam = String(items[3])
            offerCode = offerCodeParam
        }

        if let weightInKG = weightInKG, let distanceInKM = distanceInKM {
            let package = Package(id: id, weightInKG: weightInKG, distanceInKM: distanceInKM, offerCode: offerCode)
            packages.append(package)
        }
    }

    public func getTotalCost(baseDeliveryCost: Double, package: Package) -> Double {
        let totalCost = baseDeliveryCost + (package.weightInKG * weightChargedRate) + (package.distanceInKM * distanceChargedRate)
        return totalCost
    }

    public func getDiscountedCost(baseDeliveryCost: Double, package: Package) -> Double {
        let discountPercent = couponStore.checkForDiscountPercent(offerCode: package.offerCode ?? "", weightInKG: package.weightInKG, distanceInKM: package.distanceInKM)

        let totalCost = getTotalCost(baseDeliveryCost: baseDeliveryCost, package: package)
        let discountedCost = totalCost * discountPercent / 100

        return discountedCost
    }

    public func getPackageTotalDeliveryOutput(baseDeliveryCost: Double) -> String {
        var answer = ""

        packages.forEach { package in
            let discountedCost = getDiscountedCost(baseDeliveryCost: baseDeliveryCost, package: package)
            let finalCost = getTotalCost(baseDeliveryCost: baseDeliveryCost, package: package) - discountedCost

            answer += "\(package.id) \(discountedCost.removeDecimalIfNeededToString() ?? "") \(finalCost.removeDecimalIfNeededToString() ?? "")"

            if package != packages.last {
                answer += "\n"
            }
        }

        return answer.isEmpty ? "N/A" : answer
    }

    public func getPackageTotalDeliveryOutput(baseDeliveryCost: Double, numberOfVehicles: Int, maxSpeed: Double, maxCarriableWeightInKG: Double) -> String {
        let timeCosts = getTimeCost(numberOfVehicles: numberOfVehicles, maxSpeed: maxSpeed, maxCarriableWeightInKG: maxCarriableWeightInKG)
        var answer = ""

        packages.forEach { package in
            let discountedCost = getDiscountedCost(baseDeliveryCost: baseDeliveryCost, package: package)
            let finalCost = getTotalCost(baseDeliveryCost: baseDeliveryCost, package: package) - discountedCost
            let timeCost = timeCosts[package.id]

            answer += "\(package.id) \(discountedCost.removeDecimalIfNeededToString() ?? "") \(finalCost.removeDecimalIfNeededToString() ?? "") \((timeCost == nil) ? "N/A" : "\(timeCost!)")"

            if package != packages.last {
                answer += "\n"
            }
        }

        return answer.isEmpty ? "N/A" : answer
    }

    public func getTimeCost(numberOfVehicles: Int, maxSpeed: Double, maxCarriableWeightInKG: Double) -> [String: Double] {
        // Return [package.id: timeCost]
        var timeCosts: [String: Double] = [:]
        let vehicles = vehicleStore.getVehicle(count: numberOfVehicles)

        var packagesCopy = self.packages
        var getDeliveryPackagesCallTimesIndex = 0

        for _ in packagesCopy where packagesCopy.isEmpty == false { // Need to use this for loop synxtax for 'continue' keyword
            guard let earliestAvailableVehicle = vehicles.sorted(by: { $0.availableTime < $1.availableTime }).first else {
                continue
            }

            logger.debugLog("\n----------------------------------------")
            logger.debugLog("getDeliveryPackagesCallTimesIndex: \(getDeliveryPackagesCallTimesIndex), now left \(packagesCopy.map { $0.id} )")
            logger.debugLog("----------------------------------------")
            let deliveryPackages = getDeliveryPackages(packages: packagesCopy, maxCarriableWeightInKG: maxCarriableWeightInKG)
            getDeliveryPackagesCallTimesIndex += 1

            let initialAvailableTime = earliestAvailableVehicle.availableTime
            
            deliveryPackages.forEach { package in
                let timeToDeliver = (package.distanceInKM / maxSpeed).rounded(toPlaces: 2)
                let timeCost = (initialAvailableTime + timeToDeliver).rounded(toPlaces: 2)

                if package == deliveryPackages.first {
                    let newAvailableTime = earliestAvailableVehicle.availableTime + (2 * timeToDeliver)
                    earliestAvailableVehicle.setAvailableTime(newAvailableTime)
                }
                timeCosts[package.id] = timeCost
            }

            // https://stackoverflow.com/a/32938861
            // Remove all deliveryPackages packages from packagesCopy, as the packages are delivered
            packagesCopy = packagesCopy.filter { deliveryPackages.contains($0) == false }
            logger.debugLog("getTimeCost - removed \(deliveryPackages.map { $0.id }), now left \(packagesCopy.map { $0.id} )")
        }

        return timeCosts
    }

    public func getDeliveryPackages(packages: [Package], maxCarriableWeightInKG: Double) -> [Package] {
        var deliveryPackages: [Package] = []
        deliveryPackages = addDeliveryPackages(index: deliveryPackages.count, addingPackages: [])

        func addDeliveryPackages(index: Int, addingPackages: [Package]) -> [Package] {
            let firstDeliveryPackagesWeightInKG = deliveryPackages.reduce(0) { $0 + $1.weightInKG }
            let addingPackagesWeightInKG = addingPackages.reduce(0) { $0 + $1.weightInKG }

            logger.debugLog("addDeliveryPackages - firstDeliveryPackagesWeightInKG: \(firstDeliveryPackagesWeightInKG)")
            logger.debugLog("addDeliveryPackages - addingPackagesWeightInKG: \(addingPackagesWeightInKG)\(addingPackagesWeightInKG > maxCarriableWeightInKG ? ", invalid, cannot more than \(maxCarriableWeightInKG)" : "")")

            if addingPackagesWeightInKG > maxCarriableWeightInKG || index == packages.count {
                if addingPackagesWeightInKG > firstDeliveryPackagesWeightInKG && addingPackagesWeightInKG <= maxCarriableWeightInKG {
                    // Only add new package to deliveryPackages if addingPackages weight is larger than previously added deliveryPackages weight
                    // Only add new package to deliveryPackages if addingPackages weight is lesser than 200
                    // Fulfilling 'We should prefer heavier packages when there are multiple shipments with the same no. of packages.'

                    if addingPackagesWeightInKG > firstDeliveryPackagesWeightInKG && deliveryPackages.isEmpty == false {
                        // Reset deliveryPackages
                        // As the previously added deliveryPackages has lesser weight than the new pairs
                        logger.debugLog("addDeliveryPackages - deliveryPackages - removing \(deliveryPackages.map { $0.id }) replace with \(addingPackages.map { $0.id })")
                        deliveryPackages.removeAll()
                    }

                    deliveryPackages.append(contentsOf: addingPackages)
                }

                if deliveryPackages.count == addingPackages.count && firstDeliveryPackagesWeightInKG == addingPackagesWeightInKG {
                    // If both packages.count is the same and their weight is the same
                    // Compare the distanceInKM
                    // Fulfilling 'If the weights are also the same, preference should be given to the shipment which can be delivered first.'
                    let firstDeliveryPackagesDistanceInKM = deliveryPackages.reduce(0) { $0 + $1.distanceInKM }
                    let addingPackagesDistanceInKM = addingPackages.reduce(0) { $0 + $1.distanceInKM }

                    logger.debugLog("addDeliveryPackages - firstDeliveryPackagesDistanceInKM: \(firstDeliveryPackagesDistanceInKM)")
                    logger.debugLog("addDeliveryPackages - addingPackagesDistanceInKM: \(addingPackagesDistanceInKM)")

                    if addingPackagesDistanceInKM < firstDeliveryPackagesDistanceInKM {
                        logger.debugLog("addDeliveryPackages - addingPackagesDistanceInKM \(addingPackagesDistanceInKM) is larger than firstDeliveryPackagesDistanceInKM \(firstDeliveryPackagesDistanceInKM)")
                        logger.debugLog("addDeliveryPackages - deliveryPackages - replace with \(addingPackages.map { $0.id })")
                        deliveryPackages = addingPackages
                    }
                }

                logger.debugLog("============== " + (index == packages.count ? "REACH END OF LOOP" : "INVALID CASE") + " ==============")
                return deliveryPackages
            }

            // Recursive
            let nextIndex = index + 1

            var newlyAddOnPackages = addingPackages
            newlyAddOnPackages.append(packages[index])

            logger.debugLog("")
            logger.debugLog("addDeliveryPackages - addingPackages 1st - index: \(index) newlyAddOnPackages: \(newlyAddOnPackages.map { $0.id }) weightInKG: \(newlyAddOnPackages.map { $0.weightInKG })")

            // As long 'return deliveryPackages' doesn't get call, we will keep adding new packages to the deliveryPackages
            // Fulfilling 'Shipment should contain max packages vehicle can carry in a trip.'
            deliveryPackages = addDeliveryPackages(index: nextIndex, addingPackages: newlyAddOnPackages)

            logger.debugLog("")
            logger.debugLog("addDeliveryPackages - starting a new loop by removing the last package")
            logger.debugLog("addDeliveryPackages - addingPackages 2nd - index: \(index) addingPackages: \(addingPackages.map { $0.id }) weightInKG: \(addingPackages.map { $0.weightInKG })")

            deliveryPackages = addDeliveryPackages(index: nextIndex, addingPackages: addingPackages)

            logger.debugLog("addDeliveryPackages - deliveryPackages \(deliveryPackages.map { $0.id })")
            return deliveryPackages
        }

        return deliveryPackages
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private var packages: [Package] = []

    private let couponStore: CouponStore

    private let vehicleStore: VehicleStore
}
