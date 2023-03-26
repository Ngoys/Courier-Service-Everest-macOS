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

    // https://stackoverflow.com/a/52114574
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        return String(formatter.string(from: number) ?? "")
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
