// hankyeol-dev. CommonUI

import UIKit

import SnapKit
import Then

public final class RoundedButton: UIButton {
   public convenience init(
      _ title: String,
      backgroundColor: UIColor = .systemBlue,
      baseColor: UIColor = .white,
      radius: CGFloat = 10.0
   ) {
      self.init()
      configuration = .filled()
      configuration?.title = title
      configuration?.baseBackgroundColor = backgroundColor
      configuration?.baseForegroundColor = baseColor
      configuration?.background.cornerRadius = radius
   }
}
