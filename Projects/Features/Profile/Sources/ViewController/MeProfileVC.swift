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
   
   private let menuBtn: UIButton = .init().then {
      $0.setImage(.dotMenu, for: .normal)
   }
   private let profileTableView: UITableView = .init().then {
      $0.register(cellType: ProfileInfoCell.self)
      $0.register(cellType: DividerCell.self)
      $0.register(cellType: IconMenuCell.self)
      $0.register(cellType: ProfileMyPostListCell.self)
      $0.register(cellType: ProfileMyLikePostListCell.self)
      $0.sectionIndexColor = .clear
      $0.separatorColor = .clear
      $0.rowHeight = UITableView.automaticDimension
      $0.contentInsetAdjustmentBehavior = .never
   }
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      navigationItem.setRightBarButton(.init(customView: menuBtn), animated: true)
      reactor?.action.onNext(.didLoad)
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
      menuBtn.rx.tap
         .bind(with: self) { vc, _ in
            let alert = UIAlertController(title: nil,
                                          message: nil,
                                          preferredStyle: .actionSheet)
            let profileEdit = UIAlertAction(title: "내 정보 관리",
                                            style: .default) { _ in
               print("push to edit profile")
            }
            let logout = UIAlertAction(title: "로그아웃",
                                       style: .destructive) { _ in
               print("logout")
            }
            let cancel = UIAlertAction(title: "닫기", style: .cancel)
            [profileEdit, logout, cancel].forEach({ alert.addAction($0) })
            vc.present(alert, animated: true)
         }.disposed(by: disposeBag)
   }
   
   private func bindStates(reactor: MeProfileReactor) {
      let dataSource = RxTableViewSectionedReloadDataSource<MeProfileSection.Model> { data, tableView, index, item in
         switch item {
         case let .info(sectionItem):
            let cell = tableView.dequeueReusableCell(for: index) as ProfileInfoCell
            cell.setCell(sectionItem)
            return cell
         case let .post(data):
            let cell = tableView.dequeueReusableCell(for: index) as ProfileMyPostListCell
            cell.setCell(data)
            return cell
         case .divider:
            let cell = tableView.dequeueReusableCell(for: index) as DividerCell
            return cell
         case let .likes(datas):
            let cell = tableView.dequeueReusableCell(for: index) as ProfileMyLikePostListCell
            cell.setCell(datas)
            return cell
         default:
            let cell = tableView.dequeueReusableCell(for: index) as IconMenuCell
            return cell
         }
      }
      
      reactor.state.map({
         [$0.infoSection, $0.postSection, $0.likesSection]
      })
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .bind(to: profileTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
   }
}
