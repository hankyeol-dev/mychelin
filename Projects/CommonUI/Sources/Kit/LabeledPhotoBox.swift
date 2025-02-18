// hankyeol-dev. CommonUI

import UIKit
import SnapKit
import Then

public final class LabeledPhotoBox: BaseView {   
   private let label: BaseLabel = .init(.init(style: .subtitle))
   public let photoButton: RoundedButton = .init("+", backgroundColor: .grayXs, baseColor: .grayLg)
   
   public init(_ label: String) {
      super.init(frame: .zero)
      self.label.setText(label)
   }
   
   override public func setSubviews() {
      super.setSubviews()
      addSubviews(label, photoButton)
   }
   
   override public func setLayouts() {
      super.setLayouts()
      label.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
         make.height.equalTo(20.0)
      }
      photoButton.snp.makeConstraints { make in
         make.top.equalTo(label.snp.bottom).offset(10.0)
         make.width.equalTo(50.0)
         make.height.equalTo(30.0)
         make.leading.equalTo(safeAreaLayoutGuide)
      }
   }
}
