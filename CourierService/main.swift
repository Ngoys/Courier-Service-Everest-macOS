import ArgumentParser
import Foundation
import CourierService_Library

struct CourierService: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Courier Service Menu")

    mutating func run() throws {
        //----------------------------------------
        // MARK: - Menu Selection
        //----------------------------------------
        print("Menu option ('cost' or 'time'):")
        if let menuString = readLine(), let menu = Menu(rawValue: menuString) {
            print("")
            print("----------------------------------------")
            print("Calculating \(menu.name)!")
            print("----------------------------------------")
            print("")

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
                        print("Enter packages details in 'pkg_id pkg_weight_in_kg distance_in_km offer_code' format:")
//                        let packages =
//                        readLine()


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
        } else {
            print(AppError.invalidMenu.errorDescription)
            throw AppError.invalidMenu
        }
    }
}

CourierService.main()
