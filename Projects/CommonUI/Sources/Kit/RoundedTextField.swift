// hankyeol-dev. CommonUI

import UIKit

import SkyFloatingLabelTextField
import Then
import SnapKit

public final class RoundedTextField: BaseView {
   public let textField: SkyFloatingLabelTextField = .init().then {
      $0.font = .systemFont(ofSize: 12.0, weight: .light)
      $0.tintColor = .systemGray
      $0.lineColor = .systemGray4
      $0.selectedLineHeight = 2.0
   }
   
   public enum TextFieldState {
      case normal, error
   }
   
   override func setSubviews() {
      super.setSubviews()
      addSubview(textField)
   }
   
   override func setLayouts() {
      super.setLayouts()
      textField.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }
   }
   
   convenience public init(
      placeholder: String,
      keyboardType: UIKeyboardType,
      selectedTitle: String,
      isSecure: Bool = false
   ) {
      self.init()
      textField.placeholder = placeholder
      textField.keyboardType = keyboardType
      textField.selectedTitle = selectedTitle
      textField.isSecureTextEntry = isSecure
   }
}

public extension RoundedTextField {
   func setSelectedColor(by state: TextFieldState) {
      switch state {
      case .normal:
         textField.selectedLineColor = .systemGray2
         textField.selectedTitleColor = .systemBlue
      case .error:
         textField.selectedLineColor = .systemRed
         textField.selectedTitleColor = .systemRed
      }
   }
}
