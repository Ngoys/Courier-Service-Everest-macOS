import XCTest
@testable import CourierService_Library

class DeliveryViewModelTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var viewModel: DeliveryViewModel!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupViewModel() {
        viewModel = DeliveryViewModel(couponStore: CouponStore(), vehicleStore: VehicleStore())
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

    func testAddPackage() {
        
    }
}
