import ArgumentParser
import Foundation
import CourierService_Library

struct CourierService: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Courier Service Menu")

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
                let viewModel = DeliveryCostViewModel(test: "Shawn")

                //----------------------------------------
                // MARK: - Base Fare
                //----------------------------------------
                print("Enter input in 'base_delivery_cost no_of_packages' format:")
                let items = readLine()?.components(separatedBy: " ") ?? []
                if let baseFare = Double(items.first ?? "")?.rounded(toPlaces: 2), baseFare >= 0 {

                    //----------------------------------------
                    // MARK: - Package Number
                    //----------------------------------------
                    if items.indices.contains(1), let packageNumber = Int(items[1]) {
                        if packageNumber > 0 {

                            //----------------------------------------
                            // MARK: - Packages Detail
                            //----------------------------------------
                            var isAddingPackage = true
                            let finishedKeyword = "Done"

                            print("\nEnter packages details in 'pkg_id pkg_weight_in_kg distance_in_km offer_code' format:")
                            while isAddingPackage {
                                print("Enter '\(finishedKeyword)' when you finish inputting")

                                let readLine = readLine()
                                if readLine == finishedKeyword {
                                    isAddingPackage = false
                                    break
                                }

                                do {
                                    try viewModel.addPackage(text: readLine)
                                } catch {
                                    if let appError = error as? AppError {
                                        print(appError.errorDescription)
                                        print("")
                                    }
                                    continue
                                }

                                print("")
                            }

                            print(viewModel.getPackages())
                            
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
