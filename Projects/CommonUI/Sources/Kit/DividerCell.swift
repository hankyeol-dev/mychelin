// hankyeol-dev. CommonUI

import UIKit

import SnapKit

public final class DividerCell: BaseTableViewCell {
   private let back: UIView = .init()
   private let divider: UIView = .init()
   
   public override func setSubviews() {
      super.setSubviews()
      addSubview(back)
      back.addSubview(divider)
   }
   public override func setLayouts() {
      super.setLayouts()
      back.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }
      divider.snp.makeConstraints { make in
         make.verticalEdges.equalToSuperview().inset(5.0)
      }
   }
   
   public override func setView() {
      super.setView()
      back.backgroundColor = .graySm
   }
}
