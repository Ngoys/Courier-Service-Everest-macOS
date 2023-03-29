import Foundation

public class VehicleStore: BaseStore {

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    public func getVehicle(count: Int) -> [Vehicle] {
        return (0..<count).map { Vehicle(id: String($0) ) }
    }
}
