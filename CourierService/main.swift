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

            switch menu {
            case .cost:
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
                            var packages: [Package] = []
                            var isAddingPackage = true
                            let finishingKeyword = "Done"
                            
                            while isAddingPackage {
                                print("\nEnter packages details in 'pkg_id pkg_weight_in_kg distance_in_km offer_code' format:")
                                print("Enter '\(finishingKeyword)' when you finish inputting")
                                let readLine = readLine()

                                if readLine == finishingKeyword {
                                    isAddingPackage = false
                                    break
                                }

                                let items = readLine?.components(separatedBy: " ") ?? []

                                let id = items.first ?? ""
                                var weightInKG = 0.0
                                var distanceInKM = 0.0
                                var offerCode: String?

                                if items.indices.contains(1), let weightInKGParam = Double(items[1]) {
                                    weightInKG = weightInKGParam
                                } else {
                                    continue
                                }

                                if items.indices.contains(2), let distanceInKMParam = Double(items[2]) {
                                    distanceInKM = distanceInKMParam
                                } else {
                                    continue
                                }

                                if items.indices.contains(3) {
                                    let offerCodeParam = String(items[3])
                                    offerCode = offerCodeParam
                                } else {
                                    continue
                                }

                                let package = Package(id: id, weightInKG: weightInKG, distanceInKM: distanceInKM, offerCode: offerCode)
                                packages.append(package)
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
