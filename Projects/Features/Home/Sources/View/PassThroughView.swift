// hankyeol-dev. Home

import UIKit

open class PassThroughView: UIView {
   override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
      let hitView = super.hitTest(point, with: event)
      return hitView == self ? nil : hitView
   }
   
   public override init(frame: CGRect) {
      super.init(frame: frame)
      setSubviews()
      setLayouts()
      setViews()
   }
   
   required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   public func setSubviews() {}
   public func setLayouts() {}
   public func setViews() {}
}
