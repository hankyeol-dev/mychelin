// hankyeol-dev. Profile

import UIKit

import CommonUI
import Domain
import RxSwift
import SnapKit
import Then

final class ProfileInfoCell: BaseTableViewCell {
   public let disposeBag: DisposeBag = .init()
   
   private let infoBox: UIView = .init().then {
      $0.backgroundColor = .white
   }
   private let profileImage: CircleLazyImage = .init(round: 40.0)
   private let profileNick: BaseLabel = .init(.init(style: .largeTitle))
   private let followBox: UIStackView = .init()
   public let following: BaseLabel = .init(.init(style: .base, color: .grayLg))
   public let follower: BaseLabel = .init(.init(style: .base, color: .grayLg))
   
   override func setSubviews() {
      super.setSubviews()
      contentView.addSubview(infoBox)
      infoBox.addSubviews(profileImage, profileNick, followBox)
      followBox.addStackSubviews(following, follower)
   }
   
   override func setLayouts() {
      super.setLayouts()
      let safeAreaInset: CGFloat = 20.0
      infoBox.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }
      profileImage.snp.makeConstraints { make in
         make.top.equalTo(contentView.safeAreaLayoutGuide).inset(safeAreaInset)
         make.centerX.equalToSuperview()
         make.size.equalTo(80.0)
      }
      profileNick.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.top.equalTo(profileImage.snp.bottom).offset(20.0)
      }
      followBox.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.top.equalTo(profileNick.snp.bottom).offset(10.0)
         make.height.equalTo(22.0)
         make.bottom.equalTo(contentView.snp.bottom).inset(safeAreaInset)
      }
   }
   
   override func setView() {
      super.setView()
      followBox.axis = .horizontal
      followBox.distribution = .fillEqually
      followBox.spacing = 10.0
   }
}
extension ProfileInfoCell {
   func setCell(_ item: MeProfileVO) {
      if let image = item.profileImage {
         profileImage.setImage(image)
      } else {
         profileImage.setDefaultImage(UIImage(systemName: "person")!)
      }
      
      profileNick.setText(item.nick)
      following.setText("팔로잉 \(item.following.count)")
      follower.setText("팔로우 \(item.followers.count)")
   }
}
