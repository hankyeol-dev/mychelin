// hankyeol-dev. CommonUI

import UIKit
import Then
import SnapKit

public final class RoundedField: BaseView {
   private let label: BaseLabel = .init(.init(style: .subtitle))
   private let textField: UITextField = .init().then {
      $0.layer.cornerRadius = 10.0
      $0.backgroundColor = .graySm
      $0.tintColor = .black
      $0.leftViewMode = .always
      $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 20.0, height: 20.0))
      $0.rightViewMode = .always
      $0.rightView = UIView(frame: .init(x: 0, y: 0, width: 20.0, height: 20.0))
      $0.font = .systemFont(ofSize: 12.0)
   }
   
   public convenience init(_ label: String, placeholder: String = "") {
      self.init()
      self.label.setText(label)
      self.textField.placeholder = placeholder
   }
   
   override func setSubviews() {
      super.setSubviews()
      addSubviews(label, textField)
   }
   
   override func setLayouts() {
      super.setLayouts()
      let inset: CGFloat = 20.0
      label.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
      }
      textField.snp.makeConstraints { make in
         make.top.equalTo(label.snp.bottom).offset(inset - 10.0)
         make.height.equalTo(40.0)
         make.horizontalEdges.equalTo(safeAreaLayoutGuide)
      }
   }
   
   public func setLabel(_ text: String) {
      label.setText(text)
   }
   
   public func setTextField(_ text: String) {
      textField.text = text
   }
   
   public func fieldDisabled() {
      textField.textColor = .grayLg
      textField.isEnabled = false
   }
}
