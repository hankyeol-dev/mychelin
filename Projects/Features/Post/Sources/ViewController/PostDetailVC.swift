// hankyeol-dev. Post

import UIKit
import CommonUI
import Domain
import ReactorKit
import RxGesture
import Then
import SnapKit
import RxDataSources

public final class PostDetailVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   
   private let backBtn: UIButton = .init().then { button in
      button.setImage(.leftOutline.withRenderingMode(.alwaysTemplate), for: .normal)
      button.tintColor = .black
   }
   
   private let postTableView: UITableView = .init().then {
      $0.register(cellType: PostDetailCell.self)
      $0.register(cellType: DividerCell.self)
      $0.register(cellType: PostCommentCell.self)
      $0.rowHeight = UITableView.automaticDimension
//      $0.separatorStyle = .none
   }
   
   public override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   public override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationItem.setLeftBarButton(.init(customView: backBtn), animated: true)
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubview(postTableView)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      postTableView.snp.makeConstraints { make in
         make.edges.equalTo(view.safeAreaLayoutGuide)
      }
   }
   
   public override func setViews() {
      super.setViews()
   }
}

extension PostDetailVC: View {
   public func bind(reactor: PostDetailReactor) {
      bindStates(reactor)
      bindActions(reactor)
   }
   
   private func bindStates(_ reactor: PostDetailReactor) {
      let dataSource = RxTableViewSectionedReloadDataSource<PostDetailSection.Model> { _, tv, index, item in
         switch item {
         case let .post(postVO):
            let cell = tv.dequeueReusableCell(for: index) as PostDetailCell
            cell.setCell(postVO)
            cell.selectionStyle = .none
            cell.nickLabel.rx.tapGesture()
               .skip(1)
               .bind(with: self) { vc, _ in
                  print("nick")
               }.disposed(by: cell.disposeBag)
            cell.followButton.rx.tapGesture()
               .skip(1)
               .bind(with: self) { vc, _ in
                  print("follow")
               }.disposed(by: cell.disposeBag)
            return cell
         case .divider:
            let cell = tv.dequeueReusableCell(for: index) as DividerCell
            cell.selectionStyle = .none
            return cell
         case let .comment(commentVO):
            let cell = tv.dequeueReusableCell(for: index) as PostCommentCell
            cell.selectionStyle = .none
            cell.separatorInset = .init(top: 3.0, left: 20.0, bottom: 3.0, right: 20.0)
            cell.setCell(commentVO)
            return cell
         }
      }
      
      reactor.state.map({ [$0.postSection, $0.divierSection, $0.commentSection, $0.divierSection] })
         .distinctUntilChanged()
         .observe(on: MainScheduler.instance)
         .bind(to: postTableView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
   }
   
   private func bindActions(_ reactor: PostDetailReactor) {
      reactor.action.onNext(.didLoad)

   }
}
