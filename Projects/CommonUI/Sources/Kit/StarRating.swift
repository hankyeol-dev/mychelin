// hankyeol-dev. CommonUI

import UIKit
import SnapKit
import Cosmos
import Then

public class StarRating: BaseView {
   private let label: BaseLabel = .init(.init(style: .subtitle))
   public let ratingView: CosmosView = .init().then {
      $0.settings.starSize = 30.0
      $0.settings.starMargin = 20.0
      $0.settings.totalStars = 5
      $0.settings.fillMode = .half
      $0.settings.minTouchRating = 0.0
      $0.rating = 0
      $0.settings.filledImage = .starFill
      $0.settings.emptyImage = .starUnFill
   }
   
   public convenience init(_ label: String) {
      self.init()
      self.label.setText(label)
   }
   
   override func setSubviews() {
      super.setSubviews()
      addSubviews(label, ratingView)
   }
   
   override func setLayouts() {
      super.setLayouts()
      label.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
         make.height.equalTo(20.0)
      }
      ratingView.snp.makeConstraints { make in
         make.top.equalTo(label.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(safeAreaLayoutGuide)
         make.height.equalTo(40.0)
      }
   }
}
