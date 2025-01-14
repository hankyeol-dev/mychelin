// hankyeol-dev. Post

import UIKit
import CommonUI
import Common
import ReactorKit
import RxCocoa

public final class CurationDetailVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   public var curationId: String = ""
   public var didDisappearHandler: (() -> Void)?
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      self.reactor = CurationDetailReactor()
   }
   
   public override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      self.reactor = nil
      didDisappearHandler?()
   }
   
   public func setCurationId(_ curationId: String) { self.curationId = curationId }
}

extension CurationDetailVC: View {
   public func bind(reactor: CurationDetailReactor) {
      bindActions(reactor)
      bindStates(reactor)
   }
   
   private func bindActions(_ reactor: CurationDetailReactor) {
      reactor.action.onNext(.didLoad(curationId: curationId))
   }
   
   private func bindStates(_ reactor: CurationDetailReactor) {
      reactor.state.map(\.cateogry)
         .bind(onNext: { print($0) })
         .disposed(by: disposeBag)
      
      reactor.state.map(\.firstCategory)
         .bind(onNext: { print($0) })
         .disposed(by: disposeBag)
      
      reactor.state.map(\.curationPosts)
         .bind(onNext: { print($0) })
         .disposed(by: disposeBag)
   }
}
