// hankyeol-dev. App

import UIKit
import CommonUI
import Map
import Post
import Profile

public protocol TabbarCoordinatorType: Coordinator {
   var tabbarController: UITabBarController { get set }
}

public final class TabbarCoordinator: TabbarCoordinatorType {
   public var childCoordinators: [any Coordinator] = []
   public var navigationController: UINavigationController
   public var type: CoordinatorType = .tabbar
   public weak var finishDelegate: CoordinatorFinishDelegate?
   public var tabbarController: UITabBarController
   
   public init(navigationController: UINavigationController) {
      self.navigationController = navigationController
      self.tabbarController = UITabBarController()
   }
   
   public func start() {
      setTabbar(TempTabBarCase.allCases.map({ setTabController($0) }))
   }
   
   private func setTabController(_ page: TempTabBarCase) -> UIViewController {
//      let nav = UINavigationController()
      navigationController.setNavigationBarHidden(true, animated: false)
      switch page {
      case .home:
         let vc = TempMapVC()
         vc.coordinateHandler = { [weak self] action in
            switch action {
            case .toPostDetail:
               let target = TempPostDetailVC()
               target.coordinateHandler = { action in
                  switch action {
                  case .toProfile:
                     vc.navigationController?.pushViewController(TempAnotherProfileVC(), animated: true)
                  }
               }
               vc.navigationController?.pushViewController(target, animated: true)
            }
         }
         vc.tabBarItem = .init(title: "맵", image: .init(systemName: "map"), tag: 0)
         return vc
      case .mypage:
         let vc = TempProfileVC()
         vc.coordinateHandler = { [weak self] action in
            switch action {
            case .toLogout:
               self?.finish()
            }
         }
         vc.tabBarItem = .init(title: "프로필", image: .init(systemName: "person.circle"), tag: 1)
         return vc
      }
   }
   
   private func setTabbar(_ controllers: [UIViewController]) {
      tabbarController.tabBar.backgroundColor = .graySm
      tabbarController.setViewControllers(controllers.map({ UINavigationController(rootViewController: $0) }), animated: true)
      tabbarController.selectedIndex = TempTabBarCase.home.rawValue
      navigationController.pushViewController(tabbarController, animated: true)
   }
}

extension TabbarCoordinator: CoordinatorFinishDelegate {
   public func coordinatorDidFinish(_ coordinator: any Coordinator) {
      
   }
}

public enum TempTabBarCase: Int, CaseIterable {
   case home
   case mypage
   
   public var toTitle: String {
      switch self {
      case .home: return "Home"
      case .mypage: return "Mypage"
      }
   }
}
