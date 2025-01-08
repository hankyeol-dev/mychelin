// hankyeol-dev.

import UIKit

import Auth
import Domain

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   
   var window: UIWindow?
   var isLoggedIn: Bool = UserDefaultsProvider.shared.getBoolValue()
   
   func scene(
      _ scene: UIScene,
      willConnectTo session: UISceneSession,
      options connectionOptions: UIScene.ConnectionOptions
   ) {
      guard let scene = (scene as? UIWindowScene) else { return }
      
      window = UIWindow(windowScene: scene)
      window?.rootViewController = isLoggedIn
      ? MainTabbarController()
      : UINavigationController(rootViewController: AuthEntryVC())
      
      window?.makeKeyAndVisible()
   }
   
   func sceneDidDisconnect(_ scene: UIScene) {   }
   
   func sceneDidBecomeActive(_ scene: UIScene) {   }
   
   func sceneWillResignActive(_ scene: UIScene) {   }
   
   func sceneWillEnterForeground(_ scene: UIScene) {   }
   
   func sceneDidEnterBackground(_ scene: UIScene) {   }
}
