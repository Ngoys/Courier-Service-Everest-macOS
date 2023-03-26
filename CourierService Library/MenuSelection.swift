import Foundation

public enum MenuSelection: String, Hashable {
    case cost
    case time

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    public var name: String {
        switch self {
        case .cost:
            return "Total Delivery Cost"

        case .time:
            return "Total Delivery Time"
        }
    }
}
