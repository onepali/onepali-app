import Flutter
import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Firebase
    FirebaseApp.configure()
    
    // Set notification delegate (permissions will be requested later by Flutter code)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      // Don't request permissions here - let user decide when to enable notifications
      // Permissions will be requested when user accesses notification settings in the app
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle notification taps when app is in background
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                      didReceive response: UNNotificationResponse,
                                      withCompletionHandler completionHandler: @escaping () -> Void) {
    super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }
  
  // Handle notifications when app is in foreground
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                      willPresent notification: UNNotification,
                                      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
  }
  
  // Handle APNS token registration - required for Firebase Cloud Messaging
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Pass the APNS token to Firebase Messaging
    // This is required for Firebase to send push notifications
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
  
  // Handle APNS token registration failure
  override func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register for remote notifications: \(error.localizedDescription)")
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }
  
  // // Handle URL schemes for Facebook authentication and other providers
  // override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
  //   return super.application(app, open: url, options: options)
  // }
  
  // Enable dynamic orientation changes based on Flutter's SystemChrome.setPreferredOrientations
  // This method allows Flutter to control orientation programmatically
  override func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    // Return .all to allow Flutter's SystemChrome.setPreferredOrientations to control orientation
    // Flutter will filter this based on what's set via SystemChrome
    return .all
  }
}
