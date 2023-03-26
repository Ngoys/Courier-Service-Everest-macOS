import Foundation

public struct Package {
    public let id: String
    public let weightInKG: Double
    public let distanceInKM: Double
    public let offerCode: String?

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    public init(id: String, weightInKG: Double, distanceInKM: Double, offerCode: String? = nil) {
        self.id = id
        self.weightInKG = weightInKG
        self.distanceInKM = distanceInKM
        self.offerCode = offerCode
    }
}
