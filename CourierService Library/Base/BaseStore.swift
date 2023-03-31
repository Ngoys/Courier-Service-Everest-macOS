import Foundation

public class BaseStore {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    let logger = ServiceContainer.container.resolve(Logger.self)!
}
