// hankyeol-dev. Map

import UIKit
import CommonUI
import Tabman
import Pageboy

public final class PostMapTabVC: TabmanViewController {
   private var vcs: [UIViewController] = [NMapVC(), PostMapListVC()]
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      setTabView()
      navigationController?.navigationBar.isHidden = true
   }
   
   private func setTabView() {
      dataSource = self
      
      let bar = TMBar.ButtonBar()
      bar.layout.transitionStyle = .snap
      bar.layout.contentInset = .init(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
      bar.indicator.isHidden = true
      bar.backgroundView.style = .flat(color: .systemBackground)
      
      bar.buttons.customize { button in
         button.tintColor = .grayLg.withAlphaComponent(0.8)
         button.selectedTintColor = .black
      }
      
      addBar(bar, dataSource: self, at: .top)
   }
}

extension PostMapTabVC: PageboyViewControllerDataSource, TMBarDataSource {
   public func barItem(for bar: any Tabman.TMBar, at index: Int) -> any Tabman.TMBarItemable {
      let title = ["지도뷰", "리스트뷰"]
      return TMBarItem(title: title[index])
   }
   
   public func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
      return vcs.count
   }
   
   public func viewController(
      for pageboyViewController: PageboyViewController,
      at index: PageboyViewController.PageIndex
   ) -> UIViewController? {
      return vcs[index]
   }
   
   public func defaultPage(
      for pageboyViewController: PageboyViewController
   ) -> PageboyViewController.Page? {
      return nil
   }
}
