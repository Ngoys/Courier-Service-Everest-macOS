import XCTest
@testable import CourierService_Library

class VehicleStoreTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var store: VehicleStore!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupStore() {
        store = VehicleStore()
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

    func test_getVehicle() {
        setupStore()
        
        let count = 100
        let vehicles = store.getVehicle(count: count)
        XCTAssertEqual(vehicles.count, count)

        XCTAssertEqual(vehicles.first?.id, "1")
        XCTAssertEqual(vehicles.last?.id, "100")
    }
}
