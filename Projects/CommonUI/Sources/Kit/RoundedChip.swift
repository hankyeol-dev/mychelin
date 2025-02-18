// hankyeol-dev. CommonUI

import UIKit
import Then
import SnapKit

public final class RoundedChip: BaseView {
   private let text: BaseLabel = .init(.init(style: .subtitle)).then {
      $0.textAlignment = .center
   }
   
   public convenience init(_ background: UIColor, _ baseColor: UIColor) {
      self.init()
      self.backgroundColor = background
      self.text.setTextColor(baseColor)
   }
   
   override public func setSubviews() {
      super.setSubviews()
      addSubview(text)
   }
   
   override public func setLayouts() {
      super.setLayouts()
      text.snp.makeConstraints { make in
         make.center.equalToSuperview()
      }
   }
   
   override public func setView() {
      super.setView()
      layer.cornerRadius = 10.0
      clipsToBounds = true
   }
   
   public func setText(_ text: String) {
      self.text.setText(text)
   }
}
