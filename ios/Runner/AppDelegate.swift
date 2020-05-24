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

         var keys: NSDictionary?

         if let path = Bundle.main.path(forResource: "keys", ofType: "plist"){
           keys = NSDictionary(contentsOfFile: path)
         }

         if let dictionary = keys{
             let apiKey = dictionary["google_maps_api"] as? String
             GMSServices.provideAPIKey(apiKey ?? "MISSING")
         }
//        let remoteConfig = RemoteConfig.remoteConfig()
//        let settings = RemoteConfigSettings(developerModeEnabled: true)
//        settings.minimumFetchInterval = 0
//
//        remoteConfig.configSettings = settings
//        remoteConfig.fetch(withExpirationDuration: 0.1){status, error in
//            print("IN REMOTE CONFIG");
//            let googleMapsApiKey : String = remoteConfig["google_maps_api"].stringValue ?? "MISSING";
//            print(googleMapsApiKey);
//            GMSServices.provideAPIKey("AIzaSyAPt4bVD-IWPFEhebtDfqoyejghOGFDFm0")
//        }
        // GMSServices.provideAPIKey("AIzaSyAPt4bVD-IWPFEhebtDfqoyejghOGFDFm0")
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
