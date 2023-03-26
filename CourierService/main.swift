import ArgumentParser
import Foundation
import CourierService_Library

struct CourierService: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Courier Service Menu")

    mutating func run() throws {
        //----------------------------------------
        // MARK: - Menu Selection
        //----------------------------------------
        print("Please enter menu option ('cost' or 'time'):")
        if let menuString = readLine(), let menu = Menu(rawValue: menuString) {
            print("Hello, you have select menu to calculate \(menu.name)!")

            //----------------------------------------
            // MARK: - Base Fare
            //----------------------------------------
            print("Please enter the base fare:")
            if let baseFare = Double(readLine() ?? "") {

                //----------------------------------------
                // MARK: - Package Number
                //----------------------------------------
                if let packageNumber = Int(readLine() ?? "") {


                    
                } else {
                    print(AppError.invalidBaseFare.errorDescription)
                    throw AppError.invalidBaseFare
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
