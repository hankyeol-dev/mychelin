// hankyeol-dev. Auth

import UIKit

import CommonUI

import Then
import SnapKit
import RxSwift
import RxCocoa

public final class AuthEntryVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   
   private let appTitle: UILabel = .init().then {
      $0.font = .systemFont(ofSize: 20, weight: .bold)
      $0.textColor = .black
      $0.text = "S:LP2"
      $0.textAlignment = .center
   }
   private let startButton: RoundedButton = .init("시작하기", backgroundColor: .black)
   
   public override func viewDidLoad() {
      super.viewDidLoad()      
      bindActions()
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(appTitle, startButton)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      appTitle.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15.0)
         make.centerX.equalToSuperview()
      }
      startButton.snp.makeConstraints { make in
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15.0)
         make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30.0)
         make.height.equalTo(50.0)
      }
   }
   
   func bindActions() {
      startButton.rx.tap
         .bind(with: self) { owner, _ in
            let vc = LoginVC()
            vc.navigationController?.navigationBar.isHidden = false
            owner.pushToVC(vc)
         }.disposed(by: disposeBag)
   }
}
