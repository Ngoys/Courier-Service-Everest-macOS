import ArgumentParser
import Foundation
import CourierService_Library

struct CourierService: ParsableCommand {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    static let configuration = CommandConfiguration(abstract: "Courier Service Menu")

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    mutating func run() throws {
        //----------------------------------------
        // MARK: - Menu Selection
        //----------------------------------------
        print("Menu option ('cost' or 'time'):", terminator: " ")
        if let menuString = readLine(), let menu = Menu(rawValue: menuString) {
            print("")
            print("----------------------------------------")
            print("Calculating \(menu.name)!")
            print("----------------------------------------")
            print("")

            switch menu {
            case .cost:
                let viewModel = DeliveryViewModel(couponStore: ServiceContainer.container.resolve(CouponStore.self)!)

                //----------------------------------------
                // MARK: - Base Fare
                //----------------------------------------
                print("Enter input in 'base_delivery_cost no_of_packages' format:")
                let items = readLine()?.components(separatedBy: " ") ?? []
                if let baseDeliveryCost = Double(items.first ?? "")?.rounded(toPlaces: 2), baseDeliveryCost >= 0 {
                    print()

                    //----------------------------------------
                    // MARK: - Package Number
                    //----------------------------------------
                    if items.indices.contains(1), let numberOfPackages = Int(items[1]) {
                        if numberOfPackages > 0 {

                            //----------------------------------------
                            // MARK: - Packages Detail
                            //----------------------------------------
                            var count = viewModel.getPackages().count
                            while count < numberOfPackages {
                                print("Enter \((count + 1).ordinal ?? "") packages details in 'pkg_id pkg_weight_in_kg distance_in_km offer_code' format:")

                                let readLine = readLine()

                                do {
                                    try viewModel.addPackage(text: readLine)
                                    count += 1
                                } catch {
                                    if let appError = error as? AppError {
                                        print(appError.errorDescription)
                                        print()
                                    }
                                    continue
                                }

                                print()
                            }

                            print("----------------------------------------")
                            print("Answer")
                            print("----------------------------------------")
                            viewModel.getPackages().forEach { package in
                                print("\(package.id) \(viewModel.calculateDiscountedDeliveryCost(baseDeliveryCost: baseDeliveryCost, package: package).removeZerosFromEnd()) \(viewModel.calculateFinalDeliveryCost(baseDeliveryCost: baseDeliveryCost, package: package).removeZerosFromEnd())")
                            }
                            
                        } else {
                            print(AppError.packageNumberLessThan1.errorDescription)
                            throw AppError.packageNumberLessThan1
                        }
                    } else {
                        print(AppError.invalidPackageNumber.errorDescription)
                        throw AppError.invalidPackageNumber
                    }
                } else {
                    print(AppError.invalidBaseFare.errorDescription)
                    throw AppError.invalidBaseFare
                }

            case .time:
                fatalError("Shawn")
            }
        } else {
            print(AppError.invalidMenu.errorDescription)
            throw AppError.invalidMenu
        }
    }
}

CourierService.main()
