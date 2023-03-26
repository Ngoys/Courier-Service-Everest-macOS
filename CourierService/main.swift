import ArgumentParser
import Foundation
import CourierService_Library

struct Menu: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Courier Service Menu")

    mutating func run() throws {
        print("Please enter menu option ('cost' or 'time'):")

        if let menuString = readLine(), let menu = MenuSelection(rawValue: menuString) {
            print("Hello, you have select menu to calculate \(menu.name)!")

//            if let baseFare = Double(readLine()) {
//
//            } else {
//                print("Invalid menu input")
//            }
        } else {
            print("Invalid menu input")
        }
    }
}

Menu.main()
