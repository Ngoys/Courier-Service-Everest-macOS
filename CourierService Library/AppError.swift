import Foundation

public enum AppError: Error, Equatable {
    case invalidMenu
    case invalidBaseFare
    case invalidPackageNumber

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    public var errorDescription: String {
        switch self {
        case .invalidMenu:
            return "Invalid menu input"

        case .invalidBaseFare:
            return "Invalid base fare input"

        case .invalidPackageNumber:
            return "Invalid package number"
        }
    }
}
