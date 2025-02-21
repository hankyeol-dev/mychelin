// hankyeol-dev.

import UIKit
import Domain
import Data
import Profile

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
      let vc = MeProfileVC()
      vc.reactor = MeProfileReactor(MockUserUsecase(repository: MockUserRepository()))
      window?.rootViewController = UINavigationController(rootViewController: vc)
      window?.makeKeyAndVisible()
   }
   
   func sceneDidDisconnect(_ scene: UIScene) {   }
   
   func sceneDidBecomeActive(_ scene: UIScene) {
//      Task {
//         let usecase = MockAuthUsecase(repository: MockAuthRepository())
//         let result = await usecase.login(with: .init(email: env.tempEmail, password: env.tempPW))
//         switch result {
//         case .success(let success):
//            print("login \(success)")
//         case .failure(let failure):
//            print(failure.toMessage)
//         }
//      }
   }
   
   func sceneWillResignActive(_ scene: UIScene) {   }
   
   func sceneWillEnterForeground(_ scene: UIScene) {   }
   
   func sceneDidEnterBackground(_ scene: UIScene) {   }
}
