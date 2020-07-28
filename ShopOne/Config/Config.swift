/// Bym

import Foundation

final class Config {
    
    static let shared = Config()
    
    let baseURL: String
    private init() {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            fatalError("Can not get Info.plist data")
        }
        
        guard let baseURL = config["BaseURL"] as? String else {
            fatalError("Can not get Base Url")
        }
        
        self.baseURL = baseURL
        
    }
}
