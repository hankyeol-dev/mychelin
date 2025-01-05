// hankyeol-dev. Profile

import UIKit

import CommonUI
import Domain

import SnapKit
import ReactorKit
import RxCocoa
import Then
import Reusable
import RxDataSources

public final class MeProfileVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   
   private let profileTableView: UITableView = .init().then {
      $0.register(cellType: ProfileInfoCell.self)
      $0.rowHeight = UITableView.automaticDimension
      $0.contentInsetAdjustmentBehavior = .never
   }
   
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
      view.addSubview(profileTableView)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      profileTableView.snp.makeConstraints { make in
         make.top.equalToSuperview()
         make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
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
      let dataSource = RxTableViewSectionedReloadDataSource<MeProfileSection.Model> { data, tableView, index, item in
         switch item {
         case let .info(sectionItem):
            let cell = tableView.dequeueReusableCell(for: index) as ProfileInfoCell
            cell.setCell(sectionItem)
            return cell
         }
      }
      
      reactor.state.map({ [$0.infoSection] })
         .distinctUntilChanged()
         .observe(on: MainScheduler.instance)
         .bind(to: self.profileTableView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
   }
}
