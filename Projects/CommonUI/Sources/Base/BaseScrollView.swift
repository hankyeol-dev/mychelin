// hankyeol-dev. CommonUI

import UIKit
import SnapKit
import Then

public final class BaseScrollView: BaseView {
   public let scrollView: UIScrollView = .init().then {
      $0.backgroundColor = .clear
      $0.showsVerticalScrollIndicator = false
   }
   public let contentView: UIView = .init()
   private let bottomView: UIView = .init().then { $0.backgroundColor = .clear }
   
   public override func setSubviews() {
      super.setSubviews()
      addSubview(scrollView)
      scrollView.addSubview(contentView)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      scrollView.snp.makeConstraints { make in
         make.edges.equalTo(safeAreaLayoutGuide)
      }
      contentView.snp.makeConstraints { make in
         make.width.equalTo(scrollView.snp.width)
         make.verticalEdges.equalTo(scrollView)
      }
   }
   
   public func addBottomView(_ anyView: UIView, height:CGFloat = 20.0) {
      contentView.addSubview(bottomView)
      bottomView.snp.makeConstraints { make in
         make.top.equalTo(anyView.snp.bottom)
         make.height.equalTo(height)
         make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide)
      }
      bottomView.backgroundColor = .clear
   }
}
