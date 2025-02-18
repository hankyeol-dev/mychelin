// hankyeol-dev. CommonUI

import UIKit
import Then
import SnapKit

public final class LinedField: BaseView {
   private let line: UIView = .init().then {
      $0.backgroundColor = .graySm
   }
   private let label: BaseLabel = .init(.init(style: .subtitle))
   public let textField: UITextField = .init().then {
      $0.font = .systemFont(ofSize: 15.0)
      $0.tintColor = .grayLg
   }
   
   public convenience init(_ label: String, placeholder: String) {
      self.init()
      self.label.setText(label)
      self.textField.placeholder = placeholder
   }
   
   override public func setSubviews() {
      super.setSubviews()
      addSubviews(label, line, textField)
   }
   
   override public func setLayouts() {
      super.setLayouts()
      label.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
         make.height.equalTo(20.0)
      }
      textField.snp.makeConstraints { make in
         make.top.equalTo(label.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(safeAreaLayoutGuide)
         make.height.equalTo(25.0)
      }
      line.snp.makeConstraints { make in
         make.top.equalTo(textField.snp.bottom).offset(5.0)
         make.height.equalTo(1.2)
         make.horizontalEdges.equalTo(safeAreaLayoutGuide)
      }
   }
   
   public func setLineColor(_ color: UIColor) {
      line.backgroundColor = color
   }
   
   public func setTextField(_ text: String) {
      textField.text = text
   }
}
