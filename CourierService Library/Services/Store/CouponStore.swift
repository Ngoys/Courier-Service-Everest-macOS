import Foundation

public class CouponStore: BaseStore {

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    public func getCoupons() -> [Coupon] {
        return coupons
    }

    public func checkForDiscount(offerCode: String, weightInKG: Double, distanceInKM: Double) -> Double {
        guard let coupon = coupons.first(where: { $0.offerCode == offerCode }) else { return 0 }

        if distanceInKM >= coupon.minimumDistanceInKM &&
            distanceInKM <= coupon.maximumDistanceInKM &&
            weightInKG >= coupon.minimumWeightInKG &&
            weightInKG <= coupon.maximumWeightInKG {
            return coupon.discountPercent
        }

        return 0
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    let coupons = [
        Coupon(offerCode: "OFR001", discountPercent: 10, minimumDistanceInKM: 0, maximumDistanceInKM: 200, minimumWeightInKG: 70, maximumWeightInKG: 200),
        Coupon(offerCode: "OFR002", discountPercent: 7, minimumDistanceInKM: 50, maximumDistanceInKM: 150, minimumWeightInKG: 100, maximumWeightInKG: 250),
        Coupon(offerCode: "OFR003", discountPercent: 5, minimumDistanceInKM: 50, maximumDistanceInKM: 250, minimumWeightInKG: 10, maximumWeightInKG: 150),
    ]
}
