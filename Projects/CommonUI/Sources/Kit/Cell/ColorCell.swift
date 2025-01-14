// hankyeol-dev. CommonUI

import UIKit
import SnapKit
import Then

public final class ColorCell: BaseCollectionViewCell {
   private let lingView: UIView = .init().then {
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 20.0
   }
   private let innerView: UIView = .init().then {
      $0.clipsToBounds = true
      $0.backgroundColor = .graySm
      $0.layer.cornerRadius = 37.0 / 2
   }
   private let centerView: UIView = .init().then {
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 34.0 / 2
   }
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubviews(lingView, innerView, centerView)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      lingView.snp.makeConstraints { make in
         make.center.equalToSuperview()
         make.size.equalTo(40.0)
      }
      innerView.snp.makeConstraints { make in
         make.center.equalToSuperview()
         make.size.equalTo(37.0)
      }
      centerView.snp.makeConstraints { make in
         make.center.equalToSuperview()
         make.size.equalTo(34.0)
      }
   }
   
   public func setColor(_ color: UIColor, isSelected: Bool) {
      lingView.backgroundColor = isSelected ? color : .graySm
      centerView.backgroundColor = isSelected ? color : color.withAlphaComponent(0.7)
   }
}
