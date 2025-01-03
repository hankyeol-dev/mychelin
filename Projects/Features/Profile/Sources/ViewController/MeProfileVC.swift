// hankyeol-dev. Profile

import UIKit

import CommonUI
import Domain

import SnapKit
import ReactorKit
import RxCocoa

public final class MeProfileVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   
   private let profileImage: CircleLazyImage = .init(round: 28)
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      title = "마이페이지"
      self.reactor = MeProfileReactor()
   }
   
   public override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.reactor = nil
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(profileImage)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let safeAreaInset: CGFloat = 20.0
      profileImage.snp.makeConstraints { make in
         make.leading.top.equalTo(view.safeAreaLayoutGuide).inset(safeAreaInset)
         make.size.equalTo(56.0)
      }
   }
}

extension MeProfileVC: View {
   public func bind(reactor: MeProfileReactor) {
      bindActions(reactor: reactor)
      bindStates(reactor: reactor)
   }
   
   private func bindActions(reactor: MeProfileReactor) {
      reactor.action.onNext(.didLoad)
   }
   
   private func bindStates(reactor: MeProfileReactor) {
      reactor.state.map({ $0.profileObject })
         .bind(with: self) { vc, vo in
            if let vo, let profileImage = vo.profileImage {
               vc.profileImage.setImage(profileImage)
            }
         }.disposed(by: disposeBag)
   }
}
