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

    // https://stackoverflow.com/a/31390678
    func removeDecimalIfNeededToString() -> String? {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

public extension Int {

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    var ordinal: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: self))
    }
}
