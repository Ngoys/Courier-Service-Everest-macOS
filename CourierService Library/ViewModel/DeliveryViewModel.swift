import Foundation

public class DeliveryViewModel: BaseViewModel {

    //----------------------------------------
    // MARK:- Initialization
    //----------------------------------------

    public init(couponStore: CouponStore) {
        self.couponStore = couponStore
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

    private func getTotalCost(baseDeliveryCost: Double, package: Package) -> Double {
        let totalCost = baseDeliveryCost + (package.weightInKG * weightChargedRate) + (package.distanceInKM * distanceChargedRate)
        return totalCost
    }

    private func getDiscountedCost(baseDeliveryCost: Double, package: Package) -> Double {
        let discountPercent = couponStore.checkForDiscountPercent(offerCode: package.offerCode ?? "", weightInKG: package.weightInKG, distanceInKM: package.distanceInKM)

        let totalCost = getTotalCost(baseDeliveryCost: baseDeliveryCost, package: package)
        let discountedCost = totalCost * discountPercent / 100

        return discountedCost
    }

    public func getPackageOutput(baseDeliveryCost:Double, withTime: Bool) -> String {
        var answer = ""

        packages.forEach { package in
            let discountedCost = getDiscountedCost(baseDeliveryCost: baseDeliveryCost, package: package)
            let finalCost = getTotalCost(baseDeliveryCost: baseDeliveryCost, package: package) - getDiscountedCost(baseDeliveryCost: baseDeliveryCost, package: package)

            answer += "\(package.id) \(discountedCost.removeZerosFromEnd()) \(finalCost.removeZerosFromEnd())"

            if package != packages.last {
                answer += "\n"
            }
        }

        return answer.isEmpty ? "N/A" : answer
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private var packages: [Package] = []

    private let couponStore: CouponStore

    private let weightChargedRate = 10.0

    private let distanceChargedRate = 5.0
}
