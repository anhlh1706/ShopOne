/// Bym

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().tintColor = .newRed
        UINavigationBar.appearance().tintColor = .newRed

        initializeRealm()
        return true
    }
    
    func initializeRealm() {
        
        var config = Realm.Configuration.defaultConfiguration
        
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("shopOne.realm")
        Realm.Configuration.defaultConfiguration = config
        createDumpyDataIfFirstLauch()
    }
    
    private func createDumpyDataIfFirstLauch() {
        guard UserDefaults.standard.value(forKey: R.Key.firstLaunch) == nil else {
            return
        }
        
        let realmService = RealmService.shared
        
        let category = Category(title: "Drink")
        realmService.add(category)
        let items = [
            Storage(id: 0, name: "Potato", price: 20000, quantity: 20, image: UIImage(named: "noData")!),
            Storage(id: 1, name: "Pine apple", price: 30000, quantity: 10, image: UIImage(named: "noData")!),
            Storage(id: 2, name: "Momo", price: 10000, quantity: 20, image: UIImage(named: "noData")!),
            Storage(id: 3, name: "Coconut", price: 50000, quantity: 30, image: UIImage(named: "noData")!)
        ]
        items.forEach { realmService.add($0, to: category) }
        
        UserDefaults.standard.set(true, forKey: R.Key.firstLaunch)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
