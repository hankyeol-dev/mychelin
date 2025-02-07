// hankyeol-dev. Auth

import UIKit
import CommonUI
import RxSwift
import RxCocoa

public final class TempAuthVC: BaseVC, BaseCoordinatorVC {
   public var coordinateHandler: ((CoordinateAction) -> Void)?
   private let button = RoundedButton("login")
   private let button2 = RoundedButton("join")
   
   private let disposeBag = DisposeBag()
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      title = "로그인"
      button.rx.tap
         .bind(with: self) { vc, _ in
            vc.coordinateHandler?(.login)
         }.disposed(by: disposeBag)
      
      button2.rx.tap
         .bind(with: self) { vc, _ in
            vc.coordinateHandler?(.join)
         }.disposed(by: disposeBag)
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(button, button2)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      button.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20.0)
         make.height.equalTo(40)
      }
      button2.snp.makeConstraints { make in
         make.top.equalTo(button.snp.bottom).offset(15)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20.0)
         make.height.equalTo(40.0)
      }
   }
}

extension TempAuthVC {
   public enum CoordinateAction {
      case login
      case join
   }
}

public final class TempJoinVC: BaseVC {
   public override func viewDidLoad() {
      super.viewDidLoad()
      title = "join"
   }
}
