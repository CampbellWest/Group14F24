import SwiftUI
import FirebaseCore
import CoreLocation

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      let locationManager = CLLocationManager()
      locationManager.requestWhenInUseAuthorization()
      FirebaseApp.configure()
    return true
  }
}

@main
struct SystemsProjectApp: App {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
        AppView()
      }
    }
  }
}


