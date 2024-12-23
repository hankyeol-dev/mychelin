// hankyeol-dev. CommonUI

import UIKit

protocol BaseViewType: UIView {
   func setSubviews()
   func setLayouts()
   func setView()
}

public class BaseView: UIView, BaseViewType {
   override init(frame: CGRect) {
      super.init(frame: .zero)
      setSubviews()
      setLayouts()
      setView()
   }
   
   @available(*, unavailable)
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   func setSubviews() {}
   func setLayouts() {}
   func setView() {}
}
