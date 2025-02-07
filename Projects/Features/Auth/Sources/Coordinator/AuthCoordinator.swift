// hankyeol-dev. Auth

import UIKit
import CommonUI

public final class AuthCoordinator: Coordinator {
   public var type: CoordinatorType = .auth
   public var childCoordinators: [Coordinator] = []
   public var navigationController: UINavigationController
   public weak var finishDelegate: CoordinatorFinishDelegate?
   
   public init(navigationController: UINavigationController) {
      self.navigationController = navigationController
   }
   
   deinit {
      print(self, "- deinit")
   }
   
   public func start() {
      let vc = TempAuthVC()
      vc.coordinateHandler = { [weak self] action in
         switch action {
         case .login:
            
            self?.finish()
         case .join:
            let vc = TempJoinVC()
            self?.navigationController.pushViewController(vc, animated: true)
         }
      }
      navigationController.pushViewController(vc, animated: true)
   }
}
