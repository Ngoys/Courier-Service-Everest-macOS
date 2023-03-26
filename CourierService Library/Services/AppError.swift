import Foundation

public enum AppError: Error, Equatable {
    case invalidMenu
    case invalidBaseFare
    case invalidPackageNumber
    case packageNumberLessThan1
    case invalidPackageWithSameID
    case invalidWeightInKG
    case invalidDistanceInKM

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
            return "Invalid number of package"

        case .packageNumberLessThan1:
            return "Number of package must be more than 0"

        case .invalidPackageWithSameID:
            return "Cannot have package with same ID"

        case .invalidWeightInKG:
            return "Invalid weight input, input must be in digit"

        case .invalidDistanceInKM:
            return "Invalid distance input, input must be in digit"
        }
    }
}
