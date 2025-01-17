// hankyeol-dev. CommonUI

import UIKit

public enum CoordinatorType {
   case auth
   case app
   case tabbar
   case home
   case write
   case chat
   case profile
}

public protocol Coordinator: AnyObject {
   var childCoordinators: [Coordinator] { get set }
   var navigationController: UINavigationController { get set }
   var type: CoordinatorType { get }
   var finishDelegate: CoordinatorFinishDelegate? { get set }
   
   func start()
   func finish()
}

extension Coordinator {
   public func finish() {
      childCoordinators.removeAll()
      finishDelegate?.coordinatorDidFinish(self)
   }
}

public protocol CoordinatorFinishDelegate: AnyObject {
   func coordinatorDidFinish(_ coordinator: Coordinator)
}
