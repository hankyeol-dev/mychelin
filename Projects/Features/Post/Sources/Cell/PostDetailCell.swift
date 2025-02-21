// hankyeol-dev. Post

import UIKit
import CommonUI
import Domain
import SnapKit
import Then
import RxSwift

public final class PostDetailCell: BaseTableViewCell {
   public let disposeBag: DisposeBag = .init()
   
   public let nickLabel: BaseLabel = .init(.init(style: .title))
   private let categoryChip: RoundedChip = .init(.greenSm.withAlphaComponent(0.5), .greenLg)
   private let profileImage: CircleLazyImage = .init(round: 15.0)
   public let followButton: RoundedChip = .init(.systemOrange.withAlphaComponent(0.2), .systemOrange.withAlphaComponent(1.8)).then {
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
   private lazy var postImages: UICollectionView = .init(frame: .zero, collectionViewLayout: createCollectionLayout()).then {
      $0.showsHorizontalScrollIndicator = false
      $0.register(cellType: PostImageCell.self)
   }
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubviews(
         profileImage, nickLabel, categoryChip, followButton,
         postTitle, postAddressIcon, postAddress, postContent,
         postImages
      )
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let guide = contentView.safeAreaLayoutGuide
      let inset = 20.0
      
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
      postImages.snp.makeConstraints { make in
         make.top.equalTo(postContent.snp.bottom).offset(inset)
         make.leading.equalTo(guide).inset(inset)
         make.trailing.equalTo(guide)
         make.bottom.equalTo(guide).inset(inset)
      }
   }
   
   public func setCell(_ post: GetPostVO) {
      nickLabel.setText(post.creatorNick)
      postTitle.setText(post.title)
      postAddress.setText(post.address)
      postContent.setText(post.content)
      postContent.setLineHeight(5.0)
      
      if let category = FoodCategories(rawValue: post.category) {
         categoryChip.setText(category.toCategory)
      }

      if let profile = post.creatorImage {
         profileImage.setImage(profile)
      } else {
         profileImage.backgroundColor = .graySm
      }
      
      if let files = post.files, files.count > 0 {
         postImages.snp.remakeConstraints { make in
            make.top.equalTo(postContent.snp.bottom).offset(20.0)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20.0)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20.0)
            make.height.equalTo(300.0)
         }
         postImages.delegate = nil
         postImages.dataSource = nil
         Observable.just(files)
            .bind(to: postImages.rx.items(
               cellIdentifier: PostImageCell.id,
               cellType: PostImageCell.self)) { _, item, cell in
                  cell.setCell(item)
               }.disposed(by: disposeBag)
         contentView.setNeedsLayout()
      } else {
         postImages.snp.remakeConstraints { make in
            make.top.equalTo(postContent.snp.bottom).offset(20.0)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20.0)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20.0)
            make.height.equalTo(0.0)
         }
         contentView.setNeedsLayout()
      }
   }
   
   private func createCollectionLayout() -> UICollectionViewCompositionalLayout {
      let itemSize = NSCollectionLayoutSize(
         widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 8)
      
      let groupSize = NSCollectionLayoutSize(
         widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(1.0))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      section.contentInsets = .init(top: 8.0, leading: 0.0, bottom: 8.0, trailing: 0.0)
      
      return UICollectionViewCompositionalLayout(section: section)
   }
}
