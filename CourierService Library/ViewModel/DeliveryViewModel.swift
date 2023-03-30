import Foundation

public class DeliveryViewModel: BaseViewModel {

    //----------------------------------------
    // MARK:- Initialization
    //----------------------------------------

    public init(couponStore: CouponStore, vehicleStore: VehicleStore) {
        self.couponStore = couponStore
        self.vehicleStore = vehicleStore
        super.init()
//shawn delete this
        //        self.packages = [
        //            Package(id: "PKG1", weightInKG: 5, distanceInKM: 5, offerCode: "OFR001"),
        //            Package(id: "PKG2", weightInKG: 15, distanceInKM: 5, offerCode: "OFR002"),
        //            Package(id: "PKG3", weightInKG: 10, distanceInKM: 100, offerCode: "OFR003"),
        //        ]
        //        print(getPackageTotalDeliveryCostOutput(baseDeliveryCost: 100))

        self.packages = [
            Package(id: "PKG1", weightInKG: 50, distanceInKM: 30, offerCode: "OFR001"),
            Package(id: "PKG2", weightInKG: 75, distanceInKM: 125, offerCode: "OFR008"),
            Package(id: "PKG3", weightInKG: 175, distanceInKM: 100, offerCode: "OFR003"),
            Package(id: "PKG4", weightInKG: 110, distanceInKM: 60, offerCode: "OFR002"),
            Package(id: "PKG5", weightInKG: 155, distanceInKM: 95, offerCode: "NA")
        ]
        //        print(getPackageTotalDeliveryOutput(baseDeliveryCost: 100, numberOfVehicles: 2, maxSpeed: 70, maxCarriableWeightInKG: 200))

        var packagesCopy = self.packages
        packagesCopy.forEach { package in
            let pair = getHeaviestPackagesPair(packages: packagesCopy, maxCarriableWeightInKG: 200)
            print(pair)
            pair.forEach { package in
                packagesCopy.removeAll(where: { $0 == package })
            }
        }
    }

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

        return timeCosts
    }

    public func getHeaviestPackagesPair(packages: [Package], maxCarriableWeightInKG: Double) -> [Package] {
        var packagesPairs: [[Package]] = []
        packagesPairs = populatePackagesPairs(index: packagesPairs.count, populatingPackages: [])

        func populatePackagesPairs(index: Int, populatingPackages: [Package]) -> [[Package]] {
            let firstPackagesPairWeightInKG = (packagesPairs.first ?? []).reduce(0) { $0 + $1.weightInKG }
            let populatingPackagesWeightInKG = populatingPackages.reduce(0) { $0 + $1.weightInKG }

            print("populatePackagesPairs - firstPackagesPairWeightInKG: \(firstPackagesPairWeightInKG)")
            print("populatePackagesPairs - populatingPackagesWeightInKG: \(populatingPackagesWeightInKG)\(populatingPackagesWeightInKG > maxCarriableWeightInKG ? ", invalid, cannot more than \(maxCarriableWeightInKG)" : "")")

            if populatingPackagesWeightInKG > maxCarriableWeightInKG || index == packages.count - 1 {
                if populatingPackagesWeightInKG > firstPackagesPairWeightInKG && populatingPackagesWeightInKG <= maxCarriableWeightInKG {

                    packagesPairs.append(populatingPackages)
                }
                print((index == packages.count - 1 ? "REACH END OF LOOP" : "INVALID CASE") + "==============")
                return packagesPairs
            }

            // Recursive
            let nextIndex = index + 1

            var newlyAddOnPackages = populatingPackages
            newlyAddOnPackages.append(packages[index])

            print("")
            print("populatePackagesPairs - populatingPackages 1st - index: \(index) newlyAddOnPackages: \(newlyAddOnPackages.map { $0.id }) weightInKG: \(newlyAddOnPackages.map { $0.weightInKG })")
            packagesPairs = populatePackagesPairs(index: nextIndex, populatingPackages: newlyAddOnPackages)

            print("")
            print("populatePackagesPairs - starting a new loop by removing the last package")
            print("populatePackagesPairs - populatingPackages 2nd - index: \(index) populatingPackages: \(populatingPackages.map { $0.id }) weightInKG: \(populatingPackages.map { $0.weightInKG })")

            packagesPairs = populatePackagesPairs(index: nextIndex, populatingPackages: populatingPackages)
            
            return packagesPairs
        }

        return packagesPairs.first ?? []
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private var packages: [Package] = []

    private let couponStore: CouponStore

    private let vehicleStore: VehicleStore

    private let weightChargedRate = 10.0

    private let distanceChargedRate = 5.0
}
