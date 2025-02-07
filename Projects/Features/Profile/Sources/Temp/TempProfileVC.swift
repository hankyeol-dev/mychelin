// hankyeol-dev. Profile

import UIKit
import CommonUI
import RxSwift
import RxCocoa

public final class TempProfileVC: BaseVC, BaseCoordinatorVC {
   public var coordinateHandler: ((CoordinateAction) -> Void)?
   
   private let disposeBag = DisposeBag()
   private let button1 = RoundedButton("로그아웃")
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      title = "프로필"
      button1.rx.tap.bind(with: self) { vc, _ in
         vc.coordinateHandler?(.toLogout)
      }.disposed(by: disposeBag)
   }

   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(button1)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      button1.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20.0)
         make.height.equalTo(40)
      }
   }
   
   public override func setViews() {
      super.setViews()
   }
}

extension TempProfileVC {
   public enum CoordinateAction {
      case toLogout
   }
}

public final class TempProfileCoordinator: Coordinator {
   public var type: CommonUI.CoordinatorType = .profile
   public var childCoordinators: [any Coordinator] = []
   public var navigationController: UINavigationController
   public var finishDelegate: CoordinatorFinishDelegate?
   
   public init(navController: UINavigationController) {
      self.navigationController = navController
   }
   
   public func start() {
      navigationController.pushViewController(TempProfileVC(), animated: true)
   }
}
