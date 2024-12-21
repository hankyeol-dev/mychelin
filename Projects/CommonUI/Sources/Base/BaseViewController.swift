// hankyeol-dev. CommonUI

import UIKit

import RxSwift

public protocol BaseViewControllerType: UIViewController {
   var disposeBag: DisposeBag { get }
   
   func setSubviews()
   func setLayouts()
   func bindActions()
   func bindStates()
}

open class BaseVC: UIViewController, BaseViewControllerType {
   public var disposeBag: DisposeBag = .init()
   
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
   open func bindActions() {}
   open func bindStates() {}
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
