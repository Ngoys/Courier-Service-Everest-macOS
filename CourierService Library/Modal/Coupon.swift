import Foundation

public struct Coupon {
    public let offerCode: String
    public let discountPercent: Double
    public let minimumDistanceInKM: Double
    public let maximumDistanceInKM: Double
    public let minimumWeightInKG: Double
    public let maximumWeightInKG: Double

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    public init(offerCode: String, discountPercent: Double, minimumDistanceInKM: Double, maximumDistanceInKM: Double, minimumWeightInKG: Double, maximumWeightInKG: Double) {
        self.offerCode = offerCode
        self.discountPercent = discountPercent
        self.minimumDistanceInKM = minimumDistanceInKM
        self.maximumDistanceInKM = maximumDistanceInKM
        self.minimumWeightInKG = minimumWeightInKG
        self.maximumWeightInKG = maximumWeightInKG
    }
}
