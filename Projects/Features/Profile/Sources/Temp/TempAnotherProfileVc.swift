// hankyeol-dev. Profile

import UIKit
import CommonUI
import RxSwift
import RxCocoa

public final class TempAnotherProfileVC: BaseVC, BaseCoordinatorVC {
   public var coordinateHandler: ((CoordinateAction) -> Void)?
   
   private let disposeBag = DisposeBag()
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      title = "temp another profile"
   }
   
   public override func setViews() {
      super.setViews()
   }
}

extension TempAnotherProfileVC {
   public enum CoordinateAction {   }
}

public final class TempAnotherProfileCoordinator: Coordinator {
   public var type: CommonUI.CoordinatorType = .profile
   public var childCoordinators: [any Coordinator] = []
   public var navigationController: UINavigationController
   public var finishDelegate: CoordinatorFinishDelegate?
   
   public init(navController: UINavigationController) {
      self.navigationController = navController
   }
   
   public func start() {
      navigationController.pushViewController(TempAnotherProfileVC(), animated: true)
   }
}
