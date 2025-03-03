// hankyeol-dev.
import UIKit
import NMapsMap
import Domain
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
   ) -> Bool {
      NMFAuthManager.shared().clientId = nMapConfig.clientId.rawValue
      IQKeyboardManager.shared.isEnabled = true
      IQKeyboardManager.shared.resignOnTouchOutside = true
      return true
   }

   func application(
      _ application: UIApplication,
      configurationForConnecting connectingSceneSession: UISceneSession,
      options: UIScene.ConnectionOptions
   ) -> UISceneConfiguration {
      return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
   }

   func application(
      _ application: UIApplication,
      didDiscardSceneSessions sceneSessions: Set<UISceneSession>
   ) {}
}
