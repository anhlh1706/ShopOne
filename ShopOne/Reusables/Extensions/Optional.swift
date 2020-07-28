// Bym

import Foundation

extension Optional where Wrapped: Collection {
    
    var isNilOrEmpty: Bool {
        switch self {
        case let collection?:
            return collection.isEmpty
        case nil:
            return true
        }
    }
    
    var isNotNilAndNotEmpty: Bool {
        return !isNilOrEmpty
    }
    
}

extension Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        switch self {
        case let string?:
            return string.isEmpty
        case nil:
            return true
        }
    }
    
    var isNotNilAndNotEmpty: Bool {
        return !isNilOrEmpty
    }
    
}

extension Optional where Wrapped == Double {
    
    func toString() -> String {
        return String(self ?? 0)
    }
    
}

extension Optional where Wrapped == Int {
    
    func toString() -> String {
        return String(self ?? 0)
    }
    
}
