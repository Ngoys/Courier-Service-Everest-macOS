import Foundation

public enum AppError: Error, Equatable {
    case invalidMenu
    case invalidBaseFare
    case invalidPackageNumber
    case packageNumberLessThan1

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var errorDescription: String {
        switch self {
        case .invalidMenu:
            return "Invalid menu input"

        case .invalidBaseFare:
            return "Invalid base fare input"

        case .invalidPackageNumber:
            return "Invalid number of package"

        case .packageNumberLessThan1:
            return "Number of package must be more than 0"
        }
    }
}
