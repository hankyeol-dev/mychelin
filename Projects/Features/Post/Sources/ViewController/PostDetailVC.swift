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
      $0.register(cellType: SectionTitleCell.self)
      $0.rowHeight = UITableView.automaticDimension
      $0.separatorStyle = .none
   }
   private let commentBox: UIView = .init().then {
      $0.backgroundColor = .grayXs
      $0.layer.cornerRadius = 20.0
      $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
   }
   private let commentField: UITextField = .init().then {
      $0.font = .systemFont(ofSize: 13.0, weight: .regular)
      $0.tintColor = .grayLg
      $0.leftViewMode = .always
      $0.leftView = .init(frame: .init(x: 0.0, y: 0.0, width: 10.0, height: 20.0))
      $0.clearButtonMode = .whileEditing
      $0.placeholder = "댓글 작성"
   }
   public let commentBtn: RoundedChip = .init(.grayMd.withAlphaComponent(0.5), .grayLg.withAlphaComponent(1.8)).then {
      $0.setText("작성")
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
      view.addSubviews(postTableView, commentBox)
      commentBox.addSubviews(commentField, commentBtn)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      postTableView.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
         make.bottom.equalTo(commentBox.snp.top)
      }
      commentBox.snp.makeConstraints { make in
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
         make.bottom.equalToSuperview()
         make.height.equalTo(80.0)
      }
      commentField.snp.makeConstraints { make in
         make.height.equalTo(25.0)
         make.top.equalTo(commentBox.safeAreaLayoutGuide).inset(20.0)
         make.leading.equalTo(commentBox.safeAreaLayoutGuide).inset(20.0)
         make.trailing.equalTo(commentBtn.snp.leading).offset(-20.0)
      }
      commentBtn.snp.makeConstraints { make in
         make.height.equalTo(25.0)
         make.top.equalTo(commentBox.safeAreaLayoutGuide).inset(20.0)
         make.trailing.equalTo(commentBox.safeAreaLayoutGuide).inset(20.0)
         make.width.equalTo(50.0)
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
         case let .title(label):
            let cell = tv.dequeueReusableCell(for: index) as SectionTitleCell
            cell.selectionStyle = .none
            cell.setCell(label)
            return cell
         }
      }
      
      reactor.state.map({ [$0.postSection, $0.divierSection, $0.commentSectionTitle, $0.commentSection, $0.divierSection] })
         .distinctUntilChanged()
         .observe(on: MainScheduler.instance)
         .bind(to: postTableView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
   }
   
   private func bindActions(_ reactor: PostDetailReactor) {
      reactor.action.onNext(.didLoad)

   }
}
