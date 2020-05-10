import UIKit
import Firebase
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    RemoteConfig.remoteConfig().fetchAndActivate(){status, error in
      let googleMapsApiKey : String = RemoteConfig.remoteConfig()["google_maps_api"].stringValue ?? "MISSING"; 
      GMSServices.provideAPIKey(googleMapsApiKey)
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
