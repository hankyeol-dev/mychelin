// hankyeol-dev. CommonUI

import UIKit
import SnapKit
import Domain

public final class FoodCategoryButton: UIButton {
   private let categoryName: BaseLabel = .init(.init(style: .largeTitle, color: .greenLg))
   
   public override init(frame: CGRect) {
      super.init(frame: frame)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   public convenience init(_ category: FoodCategories) {
      self.init()
      addSubview(categoryName)
      backgroundColor = .greenSm.withAlphaComponent(0.5)
      layer.cornerRadius = 20.0
      
      categoryName.snp.makeConstraints { make in
         make.center.equalToSuperview()
      }
   
      updateCategory(category)
   }
   
   public func updateCategory(_ category: FoodCategories) {
      categoryName.setText(category.toCategory)
      categoryName.textAlignment = .center
   }
}
