// hankyeol-dev. Post

import UIKit
import CommonUI
import RxSwift
import RxCocoa

public final class TempPostDetailVC: BaseVC, BaseCoordinatorVC {
   public var coordinateHandler: ((CoordinateAction) -> Void)?
   
   private let disposeBag = DisposeBag()
   private let button1 = RoundedButton("프로필")
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      title = "디테일"
      
      button1.rx.tap.bind(with: self) { vc, _ in
         vc.coordinateHandler?(.toProfile)
      }.disposed(by: disposeBag)
   }
   
   public override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
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
}

extension TempPostDetailVC {
   public enum CoordinateAction {
      case toProfile
   }
}

public final class TempPostDetailCoordinator: Coordinator {
   public var type: CommonUI.CoordinatorType = .profile
   public var childCoordinators: [any Coordinator] = []
   public var navigationController: UINavigationController
   public var finishDelegate: CoordinatorFinishDelegate?
   
   public init(navController: UINavigationController) {
      self.navigationController = navController
   }
   
   public func start() {
      navigationController.pushViewController(TempPostDetailVC(), animated: true)
   }
}
