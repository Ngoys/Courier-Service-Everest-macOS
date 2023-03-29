import ArgumentParser
import Foundation
import CourierService_Library

struct CourierService: ParsableCommand {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    static let configuration = CommandConfiguration(abstract: "Courier Service Menu")

    lazy var viewModel: DeliveryViewModel = {
        return DeliveryViewModel(couponStore: ServiceContainer.container.resolve(CouponStore.self)!,
                                 vehicleStore: ServiceContainer.container.resolve(VehicleStore.self)!)
    }()

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    mutating func run() throws {
        //shawn remove this
        try viewModel.addPackage(text: "PKG3 175 100 OFR003")
        //shawn remove this

        //----------------------------------------
        // MARK: - Menu Selection
        //----------------------------------------
        print("Menu option ('cost' or 'time'):", terminator: " ")
        guard let menuString = readLine(), let menu = Menu(rawValue: menuString) else {
            print(AppError.invalidMenu.errorDescription)
            throw AppError.invalidMenu
        }

        print("")
        print("----------------------------------------")
        print("Calculating \(menu.name)! for the packages delivery")
        print("----------------------------------------")
        print("")

        //----------------------------------------
        // MARK: - BaseDeliveryCost and NumberOfPackages
        //----------------------------------------
        print("Enter input in 'base_delivery_cost no_of_packages' format:")
        let items = readLine()?.components(separatedBy: " ") ?? []
        guard let baseDeliveryCost = Double(items.first ?? "")?.rounded(toPlaces: 2), baseDeliveryCost >= 0 else {
            print(AppError.invalidBaseDeliveryCost.errorDescription)
            throw AppError.invalidBaseDeliveryCost
        }

        print("")

        //----------------------------------------
        // MARK: - Package Number
        //----------------------------------------
        guard items.indices.contains(1), let numberOfPackages = Int(items[1]) else {
            print(AppError.invalidPackageNumber.errorDescription)
            throw AppError.invalidPackageNumber
        }

        guard numberOfPackages > 0 else {
            print(AppError.packageNumberLessThan1.errorDescription)
            throw AppError.packageNumberLessThan1
        }

        //----------------------------------------
        // MARK: - Packages Detail
        //----------------------------------------
        var addedPackagesCount = 0
        while addedPackagesCount < numberOfPackages {
            print("Enter \((addedPackagesCount + 1).ordinal ?? "") packages details in 'pkg_id pkg_weight_in_kg distance_in_km offer_code' format:")

            let readLine = readLine()

            do {
                try viewModel.addPackage(text: readLine)
                addedPackagesCount += 1
            } catch {
                if let appError = error as? AppError {
                    print(appError.errorDescription)
                    print("")
                }
                continue
            }

            print("")
        }

        print("----------------------------------------")
        print("Answer")
        print("----------------------------------------")
        switch menu {
        case .cost:
            print(viewModel.getPackageTotalDeliveryCostOutput(baseDeliveryCost: baseDeliveryCost))

        case .time:

            //----------------------------------------
            // MARK: - NumberOfVehicles and MaxSpeed and MaxCarriableWeight
            //----------------------------------------
            var isAcceptingInput = true
            while isAcceptingInput {
                print("Enter input in 'no_of_vehicles max_speed max_carriable_weight' format:")

                let items = readLine()?.components(separatedBy: " ") ?? []
                if let numberOfVehicles = Int(items.first ?? ""), numberOfVehicles >= 0 {
                    if items.indices.contains(1), let maxSpeed = Double(items[1]) {
                        if items.indices.contains(2), let maxCarriableWeight = Double(items[2]) {
                            isAcceptingInput = false






                        } else {
                            print(AppError.invalidMaxCarriableWeight.errorDescription)
                        }
                    } else {
                        print(AppError.invalidMaxSpeed.errorDescription)
                    }
                } else {
                    print(AppError.numberOfVehiclesLessThan1.errorDescription)
                }
            }
        }
    }
}

CourierService.main()
