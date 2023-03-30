import Foundation

public enum EnvironmentType {
    case development
    case production
}

public struct Environment {
    public var type: EnvironmentType {
        return .production
    }
}
