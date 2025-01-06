// hankyeol-dev. Profile

import UIKit

import CommonUI
import Domain

import SnapKit
import Then

final class ProfileInfoCell: BaseTableViewCell {
   private let infoBox: UIView = .init().then {
      $0.backgroundColor = .greenSm
   }
   private let profileImage: CircleLazyImage = .init(round: 28)
   private let profileNick: BaseLabel = .init(.init(style: .largeTitle))
   private let followBox: UIStackView = .init()
   private let following: RoundedTextBox = .init(icon: .follow, text: "팔로잉: ", iconColor: .grayLg)
   private let follower: RoundedTextBox = .init(icon: .follow, text: "팔로워: ", iconColor: .grayLg)
   
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
         make.leading.top.equalTo(contentView.safeAreaLayoutGuide).inset(safeAreaInset)
         make.size.equalTo(56.0)
      }
      profileNick.snp.makeConstraints { make in
         make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(safeAreaInset)
         make.top.equalTo(profileImage.snp.bottom).offset(20.0)
      }
      followBox.snp.makeConstraints { make in
         make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(safeAreaInset)
         make.top.equalTo(profileNick.snp.bottom).offset(20.0)
         make.height.equalTo(40.0)
         make.bottom.equalTo(contentView.snp.bottom).inset(safeAreaInset)
      }
   }
   
   override func setView() {
      super.setView()
      followBox.axis = .horizontal
      followBox.distribution = .fillEqually
      followBox.spacing = 20.0
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
      follower.appendText("\(item.followers.count)명")
      following.appendText("\(item.following.count)명")
   }
}
