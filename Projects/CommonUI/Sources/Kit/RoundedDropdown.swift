// hankyeol-dev. CommonUI

import UIKit
import SnapKit
import Then

public final class RoundedDropdown: BaseView {
   private let label: BaseLabel = .init(
      .init(text: "", style: .base, color: .systemGray3))
   private let arrow: UIButton = .init().then {
      let image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
      $0.setImage(image, for: .normal)
      $0.tintColor = .grayLg
   }
   
   override public func setSubviews() {
      super.setSubviews()
      addSubviews(label, arrow)
   }
   
   override public func setLayouts() {
      super.setLayouts()
      let inset = 20.0
      label.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.leading.equalTo(safeAreaLayoutGuide).inset(inset)
      }
      arrow.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.trailing.equalTo(safeAreaLayoutGuide).inset(inset)
         make.height.equalTo(7.0)
         make.width.equalTo(15.0)
      }
   }
   
   override public func setView() {
      super.setView()
      backgroundColor = .grayXs
      layer.cornerRadius = 10.0
      clipsToBounds = true
   }
   
   public convenience init(_ placeholder: String) {
      self.init()
      label.setText(placeholder)
   }
   
   public func setLabel(_ text: String) {
      label.setText(text)
      label.setTextColor(.black)
   }
}
