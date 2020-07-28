/// Bym

import Foundation

extension Int {
    
    func addedSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        
        return formatter.string(from: NSNumber(value: self))!
    }
    
    func vndFormat() -> String {
        switch self {
        case 0..<1_000:
            return String(self)
        case 1_000..<1_000_000:
            return String(self / 1_000) + "," + String(String(self / 100).last!) + "K"
        default:
            return String(self / 1_000_000) + "," + String(String(self / 100_000).last!) + "M"
        }
    }
    
}
