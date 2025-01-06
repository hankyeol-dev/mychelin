// hankyeol-dev. CommonUI

import UIKit

import SnapKit

public final class IconMenuCell: BaseTableViewCell {
   private let cellBox: UIView = .init()
   private let iconImage: UIImageView = .init()
   private let menuLabel: BaseLabel = .init(.init(style: .base))
   private let arrowButton: UIImageView = .init()
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubviews(cellBox)
      cellBox.addSubviews(iconImage, menuLabel, arrowButton)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let safeInset = 20.0
      cellBox.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }
      iconImage.snp.makeConstraints { make in
         make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(safeInset)
         make.centerY.equalToSuperview()
         make.size.equalTo(20.0)
      }
      menuLabel.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.leading.equalTo(iconImage.snp.trailing).offset(safeInset)
         make.trailing.equalTo(arrowButton.snp.leading).offset(-safeInset)
      }
      arrowButton.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.width.equalTo(10.0)
         make.height.equalTo(15.0)
         make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(safeInset)
      }
   }
   
   public override func setView() {
      super.setView()
      contentView.backgroundColor = .white
      arrowButton.image = .init(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
      arrowButton.tintColor = .grayLg
   }
}

extension IconMenuCell {
   public func setCell(_ icon: UIImage, _ label: String, _ labelColor: UIColor = .black) {
      iconImage.image = icon
      menuLabel.setText(label)
      menuLabel.setTextColor(labelColor)
   }
}
