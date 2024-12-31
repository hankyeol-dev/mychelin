// hankyeol-dev. Profile

import UIKit

import CommonUI
import Domain

import SnapKit
import ReactorKit
import RxCocoa

public final class ProfileVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      title = "프로필"
      self.reactor = ProfileReactor()
   }
   
   public override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.reactor = nil
   }
}

extension ProfileVC: View {
   public func bind(reactor: ProfileReactor) {
      bindActions(reactor: reactor)
      bindStates(reactor: reactor)
   }
   
   private func bindActions(reactor: ProfileReactor) {
      reactor.action.onNext(.didLoad)
   }
   
   private func bindStates(reactor: ProfileReactor) {
      reactor.state.map({ $0.profileObject })
         .bind(with: self) { vc, vo in
            if let vo { print(vo) }
         }.disposed(by: disposeBag)
   }
}
