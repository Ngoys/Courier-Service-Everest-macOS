import Foundation

public enum Menu: String, Hashable {
    case cost
    case time

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var name: String {
        switch self {
        case .cost:
            return "total delivery cost"

        case .time:
            return "total delivery time"
        }
    }
}
