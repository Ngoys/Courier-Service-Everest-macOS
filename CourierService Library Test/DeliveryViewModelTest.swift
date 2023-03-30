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

    func test_addPackage() {
        setupViewModel()

        XCTAssertNoThrow(try viewModel.addPackage(text: "PKG1 5 5 OFR001"))
        XCTAssertThrowsError(try viewModel.addPackage(text: "PKG1 5 5 OFR001")) { error in
            XCTAssertEqual(error as? AppError, AppError.invalidPackageWithSameID)
        }

        //----------------------------------------
        // MARK: - Reset
        //----------------------------------------
        setupViewModel()
        XCTAssertNoThrow(try viewModel.addPackage(text: "PKG1         5      5      OFR001"))
        XCTAssertNoThrow(try viewModel.addPackage(text: "PKG2 15 5 OFR002"))
        XCTAssertNoThrow(try viewModel.addPackage(text: "PKG3 10 100 OFR003"))

        //----------------------------------------
        // MARK: - Reset
        //----------------------------------------
        setupViewModel()
        XCTAssertThrowsError(try viewModel.addPackage(text: "")) { error in
            XCTAssertEqual(error as? AppError, AppError.invalidPackageID)
        }
        XCTAssertThrowsError(try viewModel.addPackage(text: "PKG1")) { error in
            XCTAssertEqual(error as? AppError, AppError.invalidWeightInKG)
        }
        XCTAssertThrowsError(try viewModel.addPackage(text: "PKG1 🇳🇿")) { error in
            XCTAssertEqual(error as? AppError, AppError.invalidWeightInKG)
        }
        XCTAssertThrowsError(try viewModel.addPackage(text: "PKG1 5 ❤️")) { error in
            XCTAssertEqual(error as? AppError, AppError.invalidDistanceInKM)
        }
        XCTAssertNoThrow(try viewModel.addPackage(text: "PKG1 5 5 abcdefg"))
    }

    func test_getPackageTotalDeliveryCostOutput() {
        setupViewModel()

        let baseDeliveryCost = 100.0

        XCTAssertNoThrow(try viewModel.addPackage(text: "PKG1         5      5      OFR001"))
        XCTAssertNoThrow(try viewModel.addPackage(text: "PKG2 15 5 OFR002"))
        XCTAssertNoThrow(try viewModel.addPackage(text: "PKG3 10 100 OFR003"))
        XCTAssertEqual(viewModel.getPackageTotalDeliveryOutput(baseDeliveryCost: baseDeliveryCost), """
                       PKG1 0 175
                       PKG2 0 275
                       PKG3 35 665
                       """)

        //----------------------------------------
        // MARK: - Reset
        //----------------------------------------
        setupViewModel()
        XCTAssertEqual(viewModel.getPackageTotalDeliveryOutput(baseDeliveryCost: baseDeliveryCost), "N/A")
    }

    // shawn more unit test here...
}
