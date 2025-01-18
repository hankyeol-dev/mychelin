// hankyeol-dev. App

import UIKit
import CommonUI
import Domain
import Auth

public protocol AppCoordinatorType: Coordinator {
   func showAuthFlow()
   func showTabbarFlow()
}

public final class AppCoordinator: AppCoordinatorType {   
   public var childCoordinators: [any Coordinator] = []
   public var navigationController: UINavigationController
   public var type: CoordinatorType = .app
   public weak var finishDelegate: CoordinatorFinishDelegate? = nil
   
   private var isLogined: Bool {
      get {
         return UserDefaultsProvider.shared.getBoolValue()
      }
      set {
         UserDefaultsProvider.shared.setBoolValue(.isLogined, value: newValue)
      }
   }
   
   public init(navigationController: UINavigationController) {
      self.navigationController = navigationController
   }
   
   public func start() {
      if isLogined {
         showTabbarFlow()
      } else {
         showAuthFlow()
      }
   }
   
   public func showAuthFlow() {
      let coordinator = AuthCoordinator(navigationController: navigationController)
      coordinator.finishDelegate = self
      coordinator.start()
      childCoordinators.append(coordinator)
   }
   
   public func showTabbarFlow() {
      let coordinator = TabbarCoordinator(navigationController: navigationController)
      coordinator.finishDelegate = self
      coordinator.start()
      childCoordinators.append(coordinator)
   }
}

extension AppCoordinator: CoordinatorFinishDelegate {
   public func coordinatorDidFinish(_ coordinator: Coordinator) {
      childCoordinators = childCoordinators.filter({ $0.type != coordinator.type })
      
      switch coordinator.type {
      case .tabbar:
         isLogined = false
         navigationController.viewControllers.removeAll()
         showAuthFlow()
      
      case .auth:
         isLogined = true
         navigationController.viewControllers.removeAll()
         showTabbarFlow()
      
      default:
         break    
      }
   }
}
