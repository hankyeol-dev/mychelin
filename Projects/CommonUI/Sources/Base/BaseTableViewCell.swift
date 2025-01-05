// hankyeol-dev. CommonUI

import UIKit

import SnapKit
import Reusable

open class BaseTableViewCell: UITableViewCell, Reusable {
   @available(*, unavailable)
   public required init?(coder: NSCoder) {
      super.init(coder: coder)
   }
   
   public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setSubviews()
      setLayouts()
      setView()
   }
   
   open func setSubviews() {}
   open func setLayouts() {}
   open func setView() {}
}
