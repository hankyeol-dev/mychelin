// hankyeol-dev. CommonUI

import UIKit
import SnapKit
import Then

public class LabeledTextView: BaseView {
   private let placeholder: String
   
   private let label: BaseLabel = .init(.init(style: .subtitle))
   public let textView: UITextView = .init().then {
      $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
      $0.font = .systemFont(ofSize: 15.0)
      $0.textColor = .grayMd
      $0.showsVerticalScrollIndicator = false
      $0.backgroundColor = .grayXs
      $0.tintColor = .grayLg
      $0.layer.cornerRadius = 10.0
   }
   
   public init(_ label: String, placeholder: String) {
      self.placeholder = placeholder
      self.textView.text = placeholder
      self.label.setText(label)
      super.init(frame: .zero)
      self.textView.delegate = self
   }
   
   override public func setSubviews() {
      super.setSubviews()
      addSubviews(label, textView)
   }
   
   override public func setLayouts() {
      super.setLayouts()
      label.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
         make.height.equalTo(20.0)
      }
      textView.snp.makeConstraints { make in
         make.top.equalTo(label.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(safeAreaLayoutGuide)
         make.height.equalTo(100.0)
      }
   }
}

extension LabeledTextView: UITextViewDelegate {
   public func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.text == placeholder {
         textView.text = nil
         textView.textColor = .black
         textView.backgroundColor = .white
      }
   }
   
   public func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
         textView.text = placeholder
         textView.textColor = .grayMd
         textView.backgroundColor = .grayXs
      }
   }
   
   public func textViewDidChange(_ textView: UITextView) {
      if textView.text.isEmpty {
         textView.text = placeholder
         textView.textColor = .grayMd
         textView.backgroundColor = .grayXs
         textView.endEditing(true)
      }
   }
}
