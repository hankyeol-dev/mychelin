// hankyeol-dev. CommonUI

import UIKit
import SnapKit
import Then

public final class UserLocationButton: UIButton {
   private let locationImage: UIImageView = .init().then {
      $0.image = .userLocation.withRenderingMode(.alwaysTemplate)
      $0.backgroundColor = .clear
      $0.tintColor = .grayMd
   }
   
   public override init(frame: CGRect) {
      super.init(frame: frame)
      
      addSubview(locationImage)
      locationImage.snp.makeConstraints { make in
         make.center.equalToSuperview()
         make.size.equalTo(20.0)
      }
      
      backgroundColor = .grayXs
      layer.cornerRadius = 20.0
      clipsToBounds = true
   }
   
   @available(*, unavailable)
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
