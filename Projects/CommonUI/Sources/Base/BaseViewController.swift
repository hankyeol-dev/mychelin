// hankyeol-dev. CommonUI

import UIKit

import RxSwift
import ReactorKit

public protocol BaseViewControllerType: UIViewController {
   func setSubviews()
   func setLayouts()
}

open class BaseVC: UIViewController, BaseViewControllerType {   
   open override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
      setSubviews()
   }
   
   open override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      setLayouts()
   }
   
   open func setSubviews() {}
   open func setLayouts() {}
}

public extension BaseVC {
   func pushToVC<VC: UIViewController>(_ vc: VC, _ pushHandler: (() -> Void)? = nil) {
      pushHandler?()
      navigationController?.pushViewController(vc, animated: true)
   }
   
   func switchVC<VC: UIViewController>(_ vc: VC, _ switchHandler: (() -> Void)? = nil) {
      guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
      let window = UIWindow(windowScene: scene)
      window.rootViewController = UINavigationController(rootViewController: vc)
      switchHandler?()
      window.makeKeyAndVisible()
   }
}
