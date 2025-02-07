// hankyeol-dev. Map

import UIKit
import CommonUI
import RxSwift
import RxCocoa

public final class TempMapVC: BaseVC, BaseCoordinatorVC {
   public var coordinateHandler: ((CoordinateAction) -> Void)?
   
   private let disposeBag = DisposeBag()
   private let button1 = RoundedButton("포스트 디테일")
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      title = "맵"
      button1.rx.tap.bind(with: self) { vc, _ in
         vc.coordinateHandler?(.toPostDetail)
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
}

extension TempMapVC {
   public enum CoordinateAction {
      case toPostDetail
   }
}

public final class TempMapCoordinator: Coordinator {
   public var type: CommonUI.CoordinatorType = .home
   public var childCoordinators: [any Coordinator] = []
   public var navigationController: UINavigationController
   public var finishDelegate: CoordinatorFinishDelegate?
   
   public init(navController: UINavigationController) {
      self.navigationController = navController
//      navigationController.setNavigationBarHidden(true, animated: true)
   }
   
   public func start() {
      let vc = TempMapVC()
      navigationController.pushViewController(vc, animated: true)
   }
}
