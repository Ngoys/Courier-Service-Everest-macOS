import ArgumentParser
import Foundation
import CourierService_Library

struct CourierService: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Courier Service Menu")

    mutating func run() throws {
        print("Please enter menu option ('cost' or 'time'):")

        if let menuString = readLine(), let menu = Menu(rawValue: menuString) {
            print("Hello, you have select menu to calculate \(menu.name)!")

            if let baseFare = Double(readLine() ?? "") {




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
