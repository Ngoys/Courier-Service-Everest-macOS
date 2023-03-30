import XCTest
@testable import CourierService_Library

class CouponStoreTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var store: CouponStore!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupStore() {
        store = CouponStore()
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

    func test_checkForDiscountPercent() {
        setupStore()

        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR001", weightInKG: 0, distanceInKM: 0), 0.0)
        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR001", weightInKG: 44, distanceInKM: 100), 0.0)
        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR001", weightInKG: 150, distanceInKM: 100), 10)
        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR001", weightInKG: 70, distanceInKM: 0), 10)
        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR001", weightInKG: 200, distanceInKM: 200), 10)

        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR002", weightInKG: 0, distanceInKM: 0), 0.0)
        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR002", weightInKG: 44, distanceInKM: 100), 0.0)
        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR002", weightInKG: 100, distanceInKM: 88), 7)
        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR002", weightInKG: 100, distanceInKM: 50), 7)
        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR002", weightInKG: 250, distanceInKM: 150), 7)

        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR003", weightInKG: 0, distanceInKM: 0), 0.0)
        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR003", weightInKG: 9, distanceInKM: 100), 0.0)
        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR003", weightInKG: 10, distanceInKM: 50), 5)
        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR003", weightInKG: 10, distanceInKM: 50), 5)
        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "OFR003", weightInKG: 150, distanceInKM: 250), 5)

        XCTAssertEqual(store.checkForDiscountPercent(offerCode: "", weightInKG: 0, distanceInKM: 0), 0)
    }
}
