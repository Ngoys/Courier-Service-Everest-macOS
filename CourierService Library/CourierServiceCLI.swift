import ArgumentParser
import Foundation

public struct CourierServiceCLI: ParsableCommand {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    public init() { }

    //----------------------------------------
    // MARK:- View model
    //----------------------------------------

    public lazy var viewModel: DeliveryViewModel = {
        return DeliveryViewModel(couponStore: ServiceContainer.container.resolve(CouponStore.self)!,
                                 vehicleStore: ServiceContainer.container.resolve(VehicleStore.self)!)
    }()

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    public mutating func run() throws {
        //----------------------------------------
        // MARK: - Menu Selection
        //----------------------------------------
        print("Welcome to Kiki Courier Service, please enter 'cost' or 'time':")
        guard let menuString = readLine(), let menu = Menu(rawValue: menuString.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) else {
            print(AppError.invalidMenu.errorDescription)
            throw AppError.invalidMenu
        }

        print("")
        print("----------------------------------------")
        print("Calculating packages \(menu.name)")
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

        switch menu {
        case .cost:
            print("----------------------------------------")
            print("Answer")
            print("----------------------------------------")
            print(viewModel.getPackageTotalDeliveryOutput(baseDeliveryCost: baseDeliveryCost))
            print("")

        case .time:
            //----------------------------------------
            // MARK: - NumberOfVehicles and MaxSpeed and MaxCarriableWeight
            //----------------------------------------

            var isAcceptingInput = true
            while isAcceptingInput {
                print("Enter input in 'no_of_vehicles max_speed max_carriable_weight' format:")

                let items = readLine()?.components(separatedBy: " ") ?? []
                if let numberOfVehicles = Int(items.first ?? ""), numberOfVehicles > 0 {
                    if items.indices.contains(1), let maxSpeed = Double(items[1]) {
                        if maxSpeed > 0 {
                            if items.indices.contains(2), let maxCarriableWeight = Double(items[2]) {
                                if maxCarriableWeight > 0 {
                                    isAcceptingInput = false

                                    print("")
                                    print("----------------------------------------")
                                    print("Answer")
                                    print("----------------------------------------")
                                    print(viewModel.getPackageTotalDeliveryOutput(baseDeliveryCost: baseDeliveryCost, numberOfVehicles: numberOfVehicles, maxSpeed: maxSpeed, maxCarriableWeightInKG: maxCarriableWeight))
                                    print("")

                                } else {
                                    print("")
                                    print(AppError.maxCarriableWeightLessThan1.errorDescription)
                                }
                            } else {
                                print("")
                                print(AppError.invalidMaxCarriableWeight.errorDescription)
                            }
                        } else {
                            print("")
                            print(AppError.maxSpeedLessThan1.errorDescription)
                        }
                    } else {
                        print("")
                        print(AppError.invalidMaxSpeed.errorDescription)
                    }
                } else {
                    print("")
                    print(AppError.numberOfVehiclesLessThan1.errorDescription)
                }
            }
        }
    }
}
