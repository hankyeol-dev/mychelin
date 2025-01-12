// hankyeol-dev. CommonUI

import UIKit

public final class BaseLabel: UILabel {
   public struct LabelSetting {
      let text: String
      let style: LabelStyle
      let color: UIColor
      
      public init(text: String = "", style: LabelStyle, color: UIColor = .black) {
         self.text = text
         self.style = style
         self.color = color
      }
   }
   
   public enum LabelStyle {
      case base
      case largeTitle
      case title
      case subtitle
      case caption
      case error
      
      var toFont: UIFont {
         switch self {
         case .base, .error:
               .systemFont(ofSize: 12.0)
         case .largeTitle:
               .boldSystemFont(ofSize: 20.0)
         case .title:
               .boldSystemFont(ofSize: 15.0)
         case .subtitle:
               .systemFont(ofSize: 12.0, weight: .semibold)
         case .caption:
               .systemFont(ofSize: 10.0)
         }
      }
   }
   
   public override init(frame: CGRect) {
      super.init(frame: frame)
   }
   
   public required init?(coder: NSCoder) {
      super.init(coder: coder)
   }
   
   public convenience init(_ setting: LabelSetting) {
      self.init()
      text = setting.text
      font = setting.style.toFont
      textColor = setting.style == .error ? .systemRed : setting.color
   }
   
   public func setText(_ text: String) {
      self.text = text
   }
   
   public func setTextColor(_ color: UIColor) {
      self.textColor = color
   }
}
