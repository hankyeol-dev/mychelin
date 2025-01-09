// hankyeol-dev. App

import UIKit

import CommonUI
import Map
import Profile
import Post
import Chat

@frozen
public enum TabPage: Int, CaseIterable {
   case home
   case writePost
   case chat
   case profile
   
   private var toIcon: UIImage {
      switch self {
      case .home: return .pin.withRenderingMode(.alwaysTemplate)
      case .writePost: return .writePost.withRenderingMode(.alwaysTemplate)
      case .chat: return .chat.withRenderingMode(.alwaysTemplate)
      case .profile: return .profile.withRenderingMode(.alwaysTemplate)
      }
   }
   
   private var toTabTitle: String {
      switch self {
      case .home: return "동네 지도"
      case .writePost: return "글 작성"
      case .chat: return "채팅"
      case .profile: return "프로필"
      }
   }
   
   var toTabbarItem: UITabBarItem {
      return .init(title: toTabTitle, image: toIcon, tag: rawValue)
   }
   
   var toViewController: UIViewController {
      var vc: UIViewController
      switch self {
      case .home:
         vc = MapVC()
      case .writePost:
         vc = WritePostMapVC()
      case .chat:
         vc = ChatListVC()
      case .profile:
         vc = MeProfileVC()
      }
      vc.tabBarItem = toTabbarItem
      return UINavigationController(rootViewController: vc)
   }
}

final class MainTabbarController: UITabBarController {
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
      setTabbar()
   }
   
   private func setTabbar() {
      delegate = self
      tabBar.unselectedItemTintColor = .graySm
      tabBar.tintColor = .grayLg
      tabBar.backgroundColor = .white
      viewControllers = TabPage.allCases.map(\.toViewController)
   }
}

extension MainTabbarController: UITabBarControllerDelegate {
   func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
      if viewController == tabBarController.viewControllers?[1] {
         let vc = UINavigationController(rootViewController: WritePostMapVC())
         vc.modalPresentationStyle = .fullScreen
         present(vc, animated: true)
         return false
      } else { return true }
   }
}
