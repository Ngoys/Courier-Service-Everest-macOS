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
        var getHeaviestPackagesPairCallTimesIndex = 0

        for _ in packagesCopy where packagesCopy.isEmpty == false { // Need to use this for loop synxtax for 'continue' keyword
            guard let earliestAvailableVehicle = vehicles.sorted(by: { $0.availableTime < $1.availableTime }).first else {
                continue
            }

            logger.debugLog("\n----------------------------------------")
            logger.debugLog("getHeaviestPackagesPairCallTimesIndex: \(getHeaviestPackagesPairCallTimesIndex), now left \(packagesCopy.map { $0.id} )")
            logger.debugLog("----------------------------------------")
            let packagesPair = getHeaviestPackagesPair(packages: packagesCopy, maxCarriableWeightInKG: maxCarriableWeightInKG)
            getHeaviestPackagesPairCallTimesIndex += 1

            let initialAvailableTime = earliestAvailableVehicle.availableTime
            let fromLargestDistancePackages = packagesPair.sorted { $0.distanceInKM > $1.distanceInKM }

            fromLargestDistancePackages.forEach { package in
                let timeToDeliver = (package.distanceInKM / maxSpeed).rounded(toPlaces: 2)
                let timeCost = (initialAvailableTime + timeToDeliver).rounded(toPlaces: 2)

                if package == packagesPair.first {
                    let newAvailableTime = earliestAvailableVehicle.availableTime + (2 * timeToDeliver)
                    earliestAvailableVehicle.setAvailableTime(newAvailableTime)
                }
                timeCosts[package.id] = timeCost
            }

            // https://stackoverflow.com/a/32938861
            // Remove all packagesPair packages from packagesCopy, as the packages are delivered
            packagesCopy = packagesCopy.filter { packagesPair.contains($0) == false }
            logger.debugLog("getTimeCost - removed \(packagesPair.map { $0.id }), now left \(packagesCopy.map { $0.id} )")
        }

        return timeCosts
    }

    public func getHeaviestPackagesPair(packages: [Package], maxCarriableWeightInKG: Double) -> [Package] {
        var packagesPair: [Package] = []
        packagesPair = populatePackagesPair(index: packagesPair.count, populatingPackages: [])

        func populatePackagesPair(index: Int, populatingPackages: [Package]) -> [Package] {
            let firstPackagesPairWeightInKG = packagesPair.reduce(0) { $0 + $1.weightInKG }
            let populatingPackagesWeightInKG = populatingPackages.reduce(0) { $0 + $1.weightInKG }

            logger.debugLog("populatePackagesPair - firstPackagesPairWeightInKG: \(firstPackagesPairWeightInKG)")
            logger.debugLog("populatePackagesPair - populatingPackagesWeightInKG: \(populatingPackagesWeightInKG)\(populatingPackagesWeightInKG > maxCarriableWeightInKG ? ", invalid, cannot more than \(maxCarriableWeightInKG)" : "")")

            if populatingPackagesWeightInKG > maxCarriableWeightInKG || index == packages.count {
                if populatingPackagesWeightInKG > firstPackagesPairWeightInKG && populatingPackagesWeightInKG <= maxCarriableWeightInKG {
                    // Only add new package to packagesPair if populatingPackages weight is larger than previously added packagesPair weight
                    // Only add new package to packagesPair if populatingPackages weight is lesser than 200
                    // Fulfilling 'We should prefer heavier packages when there are multiple shipments with the same no. of packages.'

                    if populatingPackagesWeightInKG > firstPackagesPairWeightInKG && packagesPair.isEmpty == false {
                        // Reset packagesPair
                        // As the previously populated packagesPair has lesser weight than the new pairs
                        logger.debugLog("populatePackagesPair - packagesPair - removing \(packagesPair.map { $0.id }) replace with \(populatingPackages.map { $0.id })")
                        packagesPair.removeAll()
                    }

                    packagesPair.append(contentsOf: populatingPackages)
                }

                if packagesPair.count == populatingPackages.count && firstPackagesPairWeightInKG == populatingPackagesWeightInKG {
                    // If both packages.count is the same and their weight is the same
                    // Compare the distanceInKM
                    // Fulfilling 'If the weights are also the same, preference should be given to the shipment which can be delivered first.'
                    let firstPackagesPairDistanceInKM = packagesPair.reduce(0) { $0 + $1.distanceInKM }
                    let populatingPackagesDistanceInKM = populatingPackages.reduce(0) { $0 + $1.distanceInKM }

                    logger.debugLog("populatePackagesPair - firstPackagesPairDistanceInKM: \(firstPackagesPairDistanceInKM)")
                    logger.debugLog("populatePackagesPair - populatingPackagesDistanceInKM: \(populatingPackagesDistanceInKM)")

                    if populatingPackagesDistanceInKM < firstPackagesPairDistanceInKM {
                        logger.debugLog("populatePackagesPair - populatingPackagesDistanceInKM \(populatingPackagesDistanceInKM) is larger than firstPackagesPairDistanceInKM \(firstPackagesPairDistanceInKM)")
                        logger.debugLog("populatePackagesPair - packagesPair - replace with \(populatingPackages.map { $0.id })")
                        packagesPair = populatingPackages
                    }
                }

                logger.debugLog("============== " + (index == packages.count ? "REACH END OF LOOP" : "INVALID CASE") + " ==============")
                return packagesPair
            }

            // Recursive
            let nextIndex = index + 1

            var newlyAddOnPackages = populatingPackages
            newlyAddOnPackages.append(packages[index])

            logger.debugLog("")
            logger.debugLog("populatePackagesPair - populatingPackages 1st - index: \(index) newlyAddOnPackages: \(newlyAddOnPackages.map { $0.id }) weightInKG: \(newlyAddOnPackages.map { $0.weightInKG })")

            // As long 'return packagesPair' doesn't get call, we will keep adding new packages to the packagesPair
            // Fulfilling 'Shipment should contain max packages vehicle can carry in a trip.'
            packagesPair = populatePackagesPair(index: nextIndex, populatingPackages: newlyAddOnPackages)

            logger.debugLog("")
            logger.debugLog("populatePackagesPair - starting a new loop by removing the last package")
            logger.debugLog("populatePackagesPair - populatingPackages 2nd - index: \(index) populatingPackages: \(populatingPackages.map { $0.id }) weightInKG: \(populatingPackages.map { $0.weightInKG })")

            packagesPair = populatePackagesPair(index: nextIndex, populatingPackages: populatingPackages)

            logger.debugLog("populatePackagesPair - packagesPair \(packagesPair.map { $0.id })")
            return packagesPair
        }

        return packagesPair
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private var packages: [Package] = []

    private let couponStore: CouponStore

    private let vehicleStore: VehicleStore
}
