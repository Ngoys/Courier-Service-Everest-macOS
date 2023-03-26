import Foundation

public struct Package {
    let id: String
    let weightInKG: Double?
    let distanceInKM: Double?
    let offerCode: String?

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    public init(id: String, weightInKG: Double?, distanceInKM: Double?, offerCode: String? = nil) {
        self.id = id
        self.weightInKG = weightInKG
        self.distanceInKM = distanceInKM
        self.offerCode = offerCode
    }
}
