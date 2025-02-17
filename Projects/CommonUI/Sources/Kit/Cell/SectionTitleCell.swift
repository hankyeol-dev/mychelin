// hankyeol-dev. CommonUI

import UIKit
import SnapKit
import Then

public final class SectionTitleCell: BaseTableViewCell {
   private let titleLabel: BaseLabel = .init(.init(style: .caption)).then {
      $0.setTextColor(.grayLg.withAlphaComponent(1.2))
   }
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubview(titleLabel)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      titleLabel.snp.makeConstraints { make in
         make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20.0)
         make.top.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10.0)
      }
   }
   
   public func setCell(_ title: String) {
      titleLabel.setText(title)
   }
}
