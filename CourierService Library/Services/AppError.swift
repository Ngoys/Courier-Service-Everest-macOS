import Foundation

public enum AppError: Error, Equatable {
    case invalidMenu
    case invalidBaseDeliveryCost
    case invalidPackageNumber
    case packageNumberLessThan1
    case invalidPackageWithSameID
    case invalidWeightInKG
    case invalidDistanceInKM
    case numberOfVehiclesLessThan1
    case invalidMaxSpeed
    case invalidMaxCarriableWeight

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    public var errorDescription: String {
        switch self {
        case .invalidMenu:
            return "Invalid menu input"

        case .invalidBaseDeliveryCost:
            return "Invalid base_delivery_cost input"

        case .invalidPackageNumber:
            return "Invalid no_of_packages"

        case .packageNumberLessThan1:
            return "no_of_packages must be more than 0"

        case .invalidPackageWithSameID:
            return "Cannot have package with same ID"

        case .invalidWeightInKG:
            return "Invalid pkg_weight_in_kg input, input must be in digit"

        case .invalidDistanceInKM:
            return "Invalid distance_in_km input, input must be in digit"

        case .numberOfVehiclesLessThan1:
            return "no_of_vehicles must be more than 0"

        case .invalidMaxSpeed:
            return "Invalid max_speed input, input must be in digit"

        case .invalidMaxCarriableWeight:
            return "Invalid max_carriable_weight input, input must be in digit"
        }
    }
}
