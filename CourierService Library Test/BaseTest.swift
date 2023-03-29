import XCTest
@testable import CourierService_Library

class BaseTest: XCTestCase {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    let calendar = Calendar.current
    let today = Date()
    var midnight: Date!
    var tomorrow: Date!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    override func setUp() {
        midnight = calendar.startOfDay(for: today)
        tomorrow = calendar.date(byAdding: .day, value: 1, to: midnight)!
    }
}
