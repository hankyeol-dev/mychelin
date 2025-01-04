// hankyeol-dev. CommonUI

import UIKit

public extension UIView {
   static var id: String { return String(describing: self) }
   
   func addSubviews(_ views: UIView...) {
      views.forEach { addSubview($0) }
   }
}

public extension UIStackView {
   func addStackSubviews(_ views: UIView...) {
      views.forEach { addArrangedSubview($0) }
   }
}
