// hankyeol-dev. CommonUI

import UIKit
import Domain
import SnapKit
import Then
import RxSwift

public final class PostTableCell: BaseTableViewCell {
   public let disposeBag: DisposeBag = .init()
   private let userId: String = UserDefaultsProvider.shared.getStringValue(.userId)
   
   private let postImageBack: UIView = .init().then {
      $0.backgroundColor = .grayXs
      $0.layer.cornerRadius = 5.0
      $0.clipsToBounds = true
   }
   private let postImage: UIImageView = .init().then {
      $0.contentMode = .scaleAspectFill
      $0.clipsToBounds = true
   }
   private let postTitle: BaseLabel = .init(.init(style: .title))
   private let postRateBack: UIView = .init().then {
      $0.backgroundColor = .greenSm.withAlphaComponent(0.5)
      $0.layer.cornerRadius = 5.0
      $0.clipsToBounds = true
   }
   private let postRateStar: UIImageView = .init(image: .starFill.withRenderingMode(.alwaysTemplate)).then {
      $0.tintColor = .systemYellow
   }
   private let postRate: BaseLabel = .init(.init(style: .subtitle, color: .greenLg))
   private let postCategory: RoundedChip = .init(.errors.withAlphaComponent(0.5), .white)
   private let postContent: BaseLabel = .init(.init(style: .caption, color: .grayMd)).then {
      $0.numberOfLines = 1
   }
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubviews(postImageBack, postTitle, postRateBack, postCategory, postContent)
      postImageBack.addSubview(postImage)
      postRateBack.addSubviews(postRateStar, postRate)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let guide = contentView.safeAreaLayoutGuide
      let inset = 20.0
      postImageBack.snp.makeConstraints { make in
         make.top.bottom.leading.equalTo(guide).inset(inset)
         make.width.equalTo(100.0)
      }
      postImage.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }
      postTitle.snp.makeConstraints { make in
         make.top.equalTo(guide).inset(inset)
         make.leading.equalTo(postImageBack.snp.trailing).offset(10.0)
      }
      postRateBack.snp.makeConstraints { make in
         make.top.equalTo(postTitle.snp.bottom).offset(5.0)
         make.leading.equalTo(postImageBack.snp.trailing).offset(10.0)
         make.height.equalTo(30.0)
      }
      postRateStar.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.size.equalTo(10.0)
         make.leading.equalTo(postRateBack.safeAreaLayoutGuide).inset(10.0)
      }
      postRate.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.height.equalTo(20.0)
         make.leading.equalTo(postRateStar.snp.trailing).offset(10.0)
         make.trailing.equalTo(postRateBack.safeAreaLayoutGuide).inset(10.0)
      }
      postCategory.snp.makeConstraints { make in
         make.top.equalTo(postTitle.snp.bottom).offset(5.0)
         make.leading.equalTo(postRateBack.snp.trailing).offset(10.0)
         make.height.equalTo(30.0)
         make.width.equalTo(80.0)
      }
      postContent.snp.makeConstraints { make in
         make.bottom.trailing.equalTo(guide).inset(inset)
         make.leading.equalTo(postImageBack.snp.trailing).offset(10.0)
         make.top.equalTo(postRate.snp.bottom).offset(10.0)
      }
   }
   
   public func setCell(_ post: GetPostVO) {
      if let image = post.files,
         let first = image.first {
         postImage.setImage(first)
         postImage.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
         }
      } else {
         postImage.snp.remakeConstraints { make in
            make.size.equalTo(20.0)
            make.center.equalToSuperview()
         }
         postImage.image = FoodCategories.etc.toIcons
      }
      
      postTitle.setText(post.title)
      postRate.setText(String(post.rate))
      postCategory.setText(FoodCategories(rawValue: post.category)?.toCategory ?? FoodCategories.etc.rawValue)
      postContent.setText(post.content)
   }
}

