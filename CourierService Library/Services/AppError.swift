import Foundation

public enum AppError: Error, Equatable {
    case invalidMenu
    case invalidBaseDeliveryCost
    case invalidPackageNumber
    case packageNumberLessThan1
    case invalidPackageWithSameID
    case invalidPackageID
    case invalidWeightInKG
    case invalidDistanceInKM
    case numberOfVehiclesLessThan1
    case invalidMaxSpeed
    case maxSpeedLessThan1
    case invalidMaxCarriableWeight
    case maxCarriableWeightLessThan1

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
            return "Cannot add package with same ID as the previously added ones"

        case .invalidPackageID:
            return "Invalid pkg_id1"

        case .invalidWeightInKG:
            return "Invalid pkg_weight_in_kg input, input must be in digit"

        case .invalidDistanceInKM:
            return "Invalid distance_in_km input, input must be in digit"

        case .numberOfVehiclesLessThan1:
            return "no_of_vehicles must be more than 0"

        case .invalidMaxSpeed:
            return "Invalid max_speed input, input must be in digit"

        case .maxSpeedLessThan1:
            return "max_speed must be more than 0"

        case .invalidMaxCarriableWeight:
            return "Invalid max_carriable_weight input, input must be in digit"

        case .maxCarriableWeightLessThan1:
            return "max_carriable_weight must be more than 0"
        }
    }
}
