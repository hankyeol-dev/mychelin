// hankyeol-dev. CommonUI

import UIKit
import Domain
import Then
import SnapKit

public final class LocationSearchCell: BaseTableViewCell {
   private let imageBack: UIView = .init().then {
      $0.backgroundColor = .grayXs
      $0.layer.cornerRadius = 15.0
   }
   private let image: UIImageView = .init().then {
      $0.image = .pin.withRenderingMode(.alwaysTemplate)
      $0.tintColor = .grayLg
   }
   private let locationStack: UIStackView = .init().then {
      $0.axis = .vertical
      $0.spacing = 10.0
      $0.distribution = .fillEqually
   }
   private let locationTitle: BaseLabel = .init(.init(style: .subtitle, color: .black))
   private let locationAddress: BaseLabel = .init(.init(style: .base, color: .grayLg))
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubviews(imageBack, locationStack)
      imageBack.addSubview(image)
      locationStack.addStackSubviews(locationTitle, locationAddress)
   }
   public override func setLayouts() {
      super.setLayouts()
      let guide = contentView.safeAreaLayoutGuide
      let inset = 20.0
      imageBack.snp.makeConstraints { make in
         make.centerY.equalTo(contentView.snp.centerY)
         make.leading.equalTo(guide).inset(inset)
         make.size.equalTo(60.0)
      }
      image.snp.makeConstraints { make in
         make.center.equalToSuperview()
         make.size.equalTo(40.0)
      }
      locationStack.snp.makeConstraints { make in
         make.centerY.equalTo(contentView.snp.centerY)
         make.leading.equalTo(imageBack.snp.trailing).offset(inset)
         make.trailing.equalTo(guide).inset(inset)
      }
   }
   
   public func setCell(_ data: NaverSearchVO) {
      locationTitle.setText(data.title)
      locationAddress.setText(data.roadAddress)
   }
}
