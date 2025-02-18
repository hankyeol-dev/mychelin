// hankyeol-dev. CommonUI

import UIKit

protocol BaseViewType: UIView {
   func setSubviews()
   func setLayouts()
   func setView()
}

open class BaseView: UIView, BaseViewType {
   public override init(frame: CGRect) {
      super.init(frame: .zero)
      setSubviews()
      setLayouts()
      setView()
   }
   
   @available(*, unavailable)
   required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   open func setSubviews() {}
   open func setLayouts() {}
   open func setView() {}
}
