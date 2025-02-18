// hankyeol-dev. Home

import UIKit
import CommonUI

public final class HomeBottomPostListVC: BaseVC {
   private let listCount: Int
   
   public init(listCount: Int) {
      self.listCount = listCount
      super.init(nibName: nil, bundle: nil)
   }
   
   @MainActor required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      title = "\(listCount)개"
   }
}
