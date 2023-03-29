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
        setupViewModel()

        XCTAssertNoThrow(try viewModel.addPackage(text: "PKG1 5 5 OFR001"))
        XCTAssertThrowsError(try viewModel.addPackage(text: "PKG1 5 5 OFR001")) { error in
            XCTAssertEqual(error as? AppError, AppError.invalidPackageWithSameID)
        }
    }
}
