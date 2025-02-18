// hankyeol-dev. CommonUI

import UIKit

import SnapKit

public final class RoundedTextBox: BaseView {
   public enum IconType {
      case follow
      
      var toIcon: UIImage {
         switch self {
         case .follow: return UIImage(resource: .follow).withRenderingMode(.alwaysTemplate)
         }
      }
   }
   
   private let iconView: UIImageView = .init()
   private let textView: BaseLabel = .init(.init(style: .title))
   
   public convenience init(
      icon: IconType,
      text: String,
      bg: UIColor = .grayXs,
      iconColor: UIColor = .greenMd
   ) {
      self.init()
      
      iconView.image = icon.toIcon
      textView.setText(text)
      backgroundColor = bg
      iconView.tintColor = iconColor
      
      layer.cornerRadius = 10.0
      layoutIfNeeded()
   }
   
   override public func setSubviews() {
      super.setSubviews()
      addSubviews(iconView, textView)
   }
   
   override public func setLayouts() {
      super.setLayouts()
      iconView.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.leading.equalTo(safeAreaInsets).inset(20.0)
         make.size.equalTo(18.0)
      }
      textView.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.trailing.equalTo(safeAreaInsets).inset(20.0)
      }
   }
}

extension RoundedTextBox {
   public func appendText(_ text: String) {
      let baseText = textView.text ?? ""
      let newText = baseText + text
      textView.setText(newText)
   }
}
