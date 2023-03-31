import Foundation

public class BaseViewModel {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    let logger = ServiceContainer.container.resolve(Logger.self)!
}
