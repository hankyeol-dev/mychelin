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
      $0.register(cellType: DividerCell.self)
      $0.register(cellType: IconMenuCell.self)
      $0.sectionIndexColor = .clear
      $0.separatorColor = .clear
      $0.rowHeight = UITableView.automaticDimension
      $0.contentInsetAdjustmentBehavior = .never
   }
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      title = "마이페이지"
   }
   
   public override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
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
      
      profileTableView.rx.itemSelected
         .map({ indexPath in Reactor.Action.tapMenu(indexPath: [indexPath.section, indexPath.row]) })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
   }
   
   private func bindStates(reactor: MeProfileReactor) {
      let dataSource = RxTableViewSectionedReloadDataSource<MeProfileSection.Model> { data, tableView, index, item in
         switch item {
         case let .info(sectionItem):
            let cell = tableView.dequeueReusableCell(for: index) as ProfileInfoCell
            cell.setCell(sectionItem)
            return cell
         case .divider:
            let cell = tableView.dequeueReusableCell(for: index) as DividerCell
            return cell
         case let .edit(sectionMenu), let .post(sectionMenu):
            let cell = tableView.dequeueReusableCell(for: index) as IconMenuCell
            cell.setCell(sectionMenu.icon, sectionMenu.label)
            return cell
         case let .logout(sectionMenu):
            let cell = tableView.dequeueReusableCell(for: index) as IconMenuCell
            cell.setCell(sectionMenu.icon, sectionMenu.label, .errors)
            return cell
         }
      }
      
      reactor.state.map({
         [$0.infoSection, $0.divider, $0.editSection, $0.divider, $0.postSection, $0.divider, $0.logoutSection]
      })
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .bind(to: profileTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
   }
}
