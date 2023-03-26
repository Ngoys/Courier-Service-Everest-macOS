import Foundation

public extension Double {
    
    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    // https://stackoverflow.com/a/32581409
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded(.down) / divisor
    }
}
