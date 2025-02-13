// hankyeol-dev.

import UIKit
import Domain
import Data
import Post

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   
   var window: UIWindow?
   var isLoggedIn: Bool = UserDefaultsProvider.shared.getBoolValue()
   var coordinator: AppCoordinator!
   
   func scene(
      _ scene: UIScene,
      willConnectTo session: UISceneSession,
      options connectionOptions: UIScene.ConnectionOptions
   ) {
      guard let scene = (scene as? UIWindowScene) else { return }
      
      window = UIWindow(windowScene: scene)

//      let nav = UINavigationController()
//      window?.rootViewController = nav
//      coordinator = AppCoordinator(navigationController: nav)
//      coordinator.start()
//      let reactor = WriteMyBestReactor(SearchUsecase(searchRepository: SearchRepository()))
//      let vc = WriteMyBestVC()
//      vc.reactor = reactor
      let vc = PostDetailVC()
      vc.reactor = PostDetailReactor(MockPost1.postId)
      window?.rootViewController = UINavigationController(
         rootViewController: vc
      )
      window?.makeKeyAndVisible()
   }
   
   func sceneDidDisconnect(_ scene: UIScene) {   }
   
   func sceneDidBecomeActive(_ scene: UIScene) {   }
   
   func sceneWillResignActive(_ scene: UIScene) {   }
   
   func sceneWillEnterForeground(_ scene: UIScene) {   }
   
   func sceneDidEnterBackground(_ scene: UIScene) {   }
}
