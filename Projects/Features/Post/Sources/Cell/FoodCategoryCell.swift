// hankyeol-dev. Post

import UIKit
import CommonUI
import Domain
import SnapKit
import Then

public final class FoodCategoryCell: BaseCollectionViewCell {
   private let icon: UIImageView = .init()
   private let name: BaseLabel = .init(.init(style: .subtitle))
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubviews(icon, name)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      icon.snp.makeConstraints { make in
         make.size.equalTo(20.0)
         make.top.equalTo(contentView.safeAreaLayoutGuide).inset(20.0)
         make.centerX.equalToSuperview()
      }
      name.snp.makeConstraints { make in
         make.top.equalTo(icon.snp.bottom).offset(10.0)
         make.height.equalTo(30.0)
         make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20.0)
      }
   }
   
   public func bindCell(_ category: FoodCategories, isSelected: Bool) {
      setContentView(isSelected)
      setIcon(category, isSelected)
      setName(category, isSelected)
   }
   
   private func setContentView(_ isSelected: Bool) {
      contentView.layer.cornerRadius = 20.0
      contentView.backgroundColor = isSelected ? .black : .grayXs
   }
   
   private func setIcon(_ category: FoodCategories, _ isSelected: Bool) {
      icon.image = category.toIcons.withRenderingMode(.alwaysTemplate)
      icon.tintColor = isSelected ? .white: .grayLg
   }
   
   private func setName(_ category: FoodCategories, _ isSelected: Bool) {
      name.setText(category.toCategory)
      name.setTextColor(isSelected ? .white : .grayLg)
      name.textAlignment = .center
   }
}
