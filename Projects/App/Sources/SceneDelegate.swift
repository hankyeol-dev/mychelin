// hankyeol-dev.

import UIKit
import CoreLocation

import Auth
import Domain
import Post
import Map

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
      let vc = WritePostVC()
      vc.setLocation(
         .init(latitude: 37.47705368834194, longitude: 126.96382238950132),
         "서울 관악구 봉천동 1693-39")
      window?.rootViewController = UINavigationController(rootViewController: vc)
//      window?.rootViewController = isLoggedIn
//      ? MainTabbarController()
//      : UINavigationController(rootViewController: AuthEntryVC())
      
      window?.makeKeyAndVisible()
   }
   
   func sceneDidDisconnect(_ scene: UIScene) {   }
   
   func sceneDidBecomeActive(_ scene: UIScene) {   }
   
   func sceneWillResignActive(_ scene: UIScene) {   }
   
   func sceneWillEnterForeground(_ scene: UIScene) {   }
   
   func sceneDidEnterBackground(_ scene: UIScene) {   }
}
