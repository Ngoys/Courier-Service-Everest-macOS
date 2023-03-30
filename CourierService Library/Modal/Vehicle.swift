import Foundation

public class Vehicle {
    public let id: String

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    public private(set) var availableTime: Double = 0

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    public init(id: String) {
        self.id = id
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    public func setAvailableTime(_ availableTime: Double) {
        self.availableTime = availableTime
    }
}
