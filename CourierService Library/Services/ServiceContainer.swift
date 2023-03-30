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

        container.register(VehicleStore.self) { r -> VehicleStore in
            return VehicleStore()
        }.inObjectScope(.container)

        container.register(Environment.self) { r -> Environment in
            return Environment()
        }.inObjectScope(.container)

        container.register(Logger.self) { r -> Logger in
            return Logger(environment: ServiceContainer.container.resolve(Environment.self)!)
        }.inObjectScope(.container)

        return container
    }
}
