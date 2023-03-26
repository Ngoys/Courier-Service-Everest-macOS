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
            print("Calculating \(menu.name)!")

            //----------------------------------------
            // MARK: - Base Fare
            //----------------------------------------
            print("Enter the base fare:")
            if let baseFare = Double(readLine() ?? "")?.rounded(toPlaces: 2) {
                
                //----------------------------------------
                // MARK: - Package Number
                //----------------------------------------
                print("Enter the number of packages:")
                if let packageNumber = Int(readLine() ?? "") {
                    if packageNumber > 0 {

                        //----------------------------------------
                        // MARK: - Packages Detail
                        //----------------------------------------
                        print("Enter packages details in 'pkg_id pkg_weight_in_kg distance_in_km offer_code' format:")
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
