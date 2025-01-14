// hankyeol-dev. CommonUI

import UIKit
import Reusable

open class BaseCollectionViewCell: UICollectionViewCell, Reusable {
   @available(*, unavailable)
   public required init?(coder: NSCoder) {
      super.init(coder: coder)
   }
   
   public override init(frame: CGRect) {
      super.init(frame: frame)
      setSubviews()
      setLayouts()
      setView()
   }
   
   open func setSubviews() {}
   open func setLayouts() {}
   open func setView() {}
}
