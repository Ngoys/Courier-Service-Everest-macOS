import Foundation

public class Logger {

    //----------------------------------------
    // MARK:- Initialization
    //----------------------------------------

    public init(environment: Environment) {
        self.environment = environment
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func debugLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        switch environment.type {
        case .development:
            // Only print log in development environment, to not mix up with CLI application
            print(items, separator: separator, terminator: terminator)

        default:
            break
        }
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private var environment: Environment
}
