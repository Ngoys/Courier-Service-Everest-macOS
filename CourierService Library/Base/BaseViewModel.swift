import Foundation

public class BaseViewModel {

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    let logger = ServiceContainer.container.resolve(Logger.self)!
}
