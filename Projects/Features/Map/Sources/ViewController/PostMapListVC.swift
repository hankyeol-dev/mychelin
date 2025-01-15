// hankyeol-dev. Map

import UIKit
import CommonUI
import SnapKit
import Then

public final class PostMapListVC: BaseVC {
   private let tableView: UITableView = .init().then {
      $0.backgroundColor = .grayXs
   }
   
   public override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubview(tableView)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      tableView.snp.makeConstraints { make in
         make.edges.equalTo(view.safeAreaLayoutGuide)
      }
   }
}
