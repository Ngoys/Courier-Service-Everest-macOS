import Foundation

public struct Package: Equatable {
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

    //----------------------------------------
    // MARK: - Equatable protocols
    //----------------------------------------

    public static func == (lhs: Package, rhs: Package) -> Bool {
        lhs.id == rhs.id
    }
}
