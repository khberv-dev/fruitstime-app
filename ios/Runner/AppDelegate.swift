import UIKit
import Flutter
import Firebase
import YandexMapsMobile

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    YMKMapKit.setApiKey("9b104dbc-7702-4a81-a7c4-e03acf385e52")

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    clearBadge(application)

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    clearBadge(application)
  }

  private func clearBadge(_ application: UIApplication) {
    if #available(iOS 17.0, *) {
      UNUserNotificationCenter.current().setBadgeCount(0) { _ in }
    } else {
      application.applicationIconBadgeNumber = 0
    }
  }
}
