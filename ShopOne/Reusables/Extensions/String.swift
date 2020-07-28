/// Bym

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func prefix(maxLength: Int) -> String {
        return String(prefix(maxLength))
    }
    
    func suffix(maxLength: Int) -> String {
        return String(suffix(maxLength))
    }
    
    var isBackspace: Bool {
        let char = cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
    
    var standardlized: String {
        return components(separatedBy: .whitespacesAndNewlines)
            .filter({ !$0.isEmpty }).joined(separator: " ")
    }
}
