// hankyeol-dev. Post

import UIKit
import CommonUI
import Domain
import ReactorKit
import RxGesture
import Then
import SnapKit

public final class PostDetailVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   
   private let backBtn: UIButton = .init().then { button in
      button.setImage(.leftOutline.withRenderingMode(.alwaysTemplate), for: .normal)
      button.tintColor = .black
   }
   private let scroll: BaseScrollView = .init()
   private let nickLabel: BaseLabel = .init(.init(style: .title, color: .grayLg))
   private let categoryChip: RoundedChip = .init(.greenSm.withAlphaComponent(0.5), .greenLg)
   private let profileImage: CircleLazyImage = .init(round: 15.0)
   private let followButton: RoundedChip = .init(.systemOrange.withAlphaComponent(0.2), .systemOrange.withAlphaComponent(1.8)).then {
      $0.setText("+ 팔로우")
   }
   private let postTitle: BaseLabel = .init(.init(style: .xLargeTitle)).then {
      $0.numberOfLines = 2
   }
   private let postAddressIcon: UIImageView = .init(image: .pin.withRenderingMode(.alwaysTemplate)).then {
      $0.tintColor = .grayLg
   }
   private let postAddress: BaseLabel = .init(.init(style: .title, color: .grayLg))
   private let postContent: BaseLabel = .init(.init(style: .base)).then {
      $0.numberOfLines = 0
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
      view.addSubview(scroll)
      scroll.contentView.addSubviews(
         profileImage, nickLabel, categoryChip, followButton,
         postTitle, postAddressIcon, postAddress, postContent
      )
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let guide = scroll.contentView.safeAreaLayoutGuide
      let inset = 20.0
      
      scroll.snp.makeConstraints { make in
         make.edges.equalTo(view.safeAreaLayoutGuide)
      }
      categoryChip.snp.makeConstraints { make in
         make.top.leading.equalTo(guide).inset(inset)
         make.height.equalTo(36.0)
         make.width.greaterThanOrEqualTo(80.0)
      }
      profileImage.snp.makeConstraints { make in
         make.top.equalTo(categoryChip.snp.bottom).offset(inset)
         make.leading.equalTo(guide).inset(inset)
         make.size.equalTo(30.0)
      }
      nickLabel.snp.makeConstraints { make in
         make.height.equalTo(30.0)
         make.centerY.equalTo(profileImage.snp.centerY)
         make.leading.equalTo(profileImage.snp.trailing).offset(10.0)
      }
      followButton.snp.makeConstraints { make in
         make.height.equalTo(30.0)
         make.width.equalTo(70.0)
         make.centerY.equalTo(profileImage.snp.centerY)
         make.trailing.equalTo(guide).inset(inset)
      }
      postTitle.snp.makeConstraints { make in
         make.top.equalTo(profileImage.snp.bottom).offset(inset + 10.0)
         make.horizontalEdges.equalTo(guide).inset(inset)
      }
      postAddressIcon.snp.makeConstraints { make in
         make.top.equalTo(postTitle.snp.bottom).offset(inset - 5.0)
         make.size.equalTo(15.0)
         make.leading.equalTo(guide).inset(inset)
      }
      postAddress.snp.makeConstraints { make in
         make.leading.equalTo(postAddressIcon.snp.trailing).offset(5.0)
         make.height.equalTo(20.0)
         make.centerY.equalTo(postAddressIcon.snp.centerY)
      }
      postContent.snp.makeConstraints { make in
         make.top.equalTo(postAddress.snp.bottom).offset(inset)
         make.horizontalEdges.equalTo(guide).inset(inset)
      }
      scroll.addBottomView(postContent)
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
      reactor.state.map(\.post)
         .bind(with: self) { vc, post in
            if let post {
               vc.nickLabel.setText(post.creatorNick)
               vc.postTitle.setText(post.title)
               vc.postAddress.setText(post.address)
               vc.postContent.setText(post.content)
               vc.postContent.setLineHeight(5.0)
               
               if let category = FoodCategories(rawValue: post.category) {
                  vc.categoryChip.setText(category.toCategory)
               }

               if let profile = post.creatorImage {
                  vc.profileImage.setImage(profile)
               } else {
                  vc.profileImage.backgroundColor = .graySm
               }
            }
         }.disposed(by: disposeBag)
   }
   
   private func bindActions(_ reactor: PostDetailReactor) {
      reactor.action.onNext(.didLoad)
      
      followButton.rx.tapGesture()
         .bind(with: self) { vc, _ in
            print(#function)
         }.disposed(by: disposeBag)
   }
}
