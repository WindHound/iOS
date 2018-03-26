import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        let locationManager = LocationManager.shared
        locationManager.requestWhenInUseAuthorization()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        CoreDataStack.saveContext()
        
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        CoreDataStack.saveContext()
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }
    
    func applicationDidBecomeActive(_ application: UIApplication) { }

}
