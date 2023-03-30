import Foundation

public class BaseStore {

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    let logger = ServiceContainer.container.resolve(Logger.self)!
}
