import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL,
                            options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    // Ensure the URL scheme matches your app's custom scheme.
    guard url.scheme == "pickup", let host = url.host else {
      return false
    }

    let link = url.absoluteString
    // Send the URL to Flutter via a channel.
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.pickup/deeplink",
                                       binaryMessenger: controller.binaryMessenger)
    channel.invokeMethod("openPage", arguments: link)

    return true
  }
}
