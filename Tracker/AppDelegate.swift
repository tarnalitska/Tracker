import UIKit
import CoreData

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIColorTransformer.register()
        ValueTransformer.setValueTransformer(
            CodableWeekdaySetTransformer(),
            forName: NSValueTransformerName("CodableWeekdaySetTransformer")
        )
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataProvider.shared.save()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataProvider.shared.save()
    }
}
