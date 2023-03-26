import Foundation
import Swinject

public class ServiceContainer {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    public static let container: Container = {
        var container: Container = Container()
        container = ServiceContainer.registerStores(inContainer: container)
        return container
    }()

    //----------------------------------------
    // MARK: - Services
    //----------------------------------------

    private static func registerStores(inContainer container: Container) -> Container {
        container.register(CouponStore.self) { r -> CouponStore in
            return CouponStore()
        }.inObjectScope(.container)

        return container
    }
}
