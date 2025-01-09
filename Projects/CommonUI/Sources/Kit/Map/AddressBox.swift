// hankyeol-dev. CommonUI

import UIKit
import SnapKit
import Then

public final class AddressBox: BaseView {
   private let back: UIView = .init().then {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 10.0
   }
   private let icon: UIImageView = .init().then {
      $0.image = .pin.withRenderingMode(.alwaysTemplate)
      $0.contentMode = .scaleAspectFit
      $0.tintColor = .grayMd
   }
   private let address: BaseLabel = .init(.init(style: .subtitle)).then {
      $0.textColor = .grayLg
   }
   
   override func setSubviews() {
      super.setSubviews()
      addSubview(back)
      back.addSubviews(icon, address)
   }
   
   override func setLayouts() {
      super.setLayouts()
      let safe: CGFloat = 20.0
      back.snp.makeConstraints { make in
         make.height.equalTo(safe * 2)
         make.horizontalEdges.equalToSuperview()
      }
      icon.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.size.equalTo(safe)
         make.leading.equalTo(safeAreaLayoutGuide).inset(safe - 5.0)
      }
      address.snp.makeConstraints { make in
         make.centerY.equalTo(icon.snp.centerY)
         make.leading.equalTo(icon.snp.trailing).offset(safe - 5.0)
      }
   }
   
   public func setAddress(_ addressString: String) {
      address.setText(addressString)
   }
   
   public func setBackground(_ color: UIColor) {
      back.backgroundColor = color
   }
}
