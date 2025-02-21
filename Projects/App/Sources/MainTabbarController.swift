// hankyeol-dev. App

import UIKit

import CommonUI
import Map
import Profile
import Post
import Home
import Data
import Domain

@frozen
public enum TabPage: Int, CaseIterable {
   case home
   case writePost
   case profile
   
   private var toIcon: UIImage {
      switch self {
      case .home: return .pin.withRenderingMode(.alwaysTemplate)
      case .writePost: return .starFill.withRenderingMode(.alwaysTemplate)
      case .profile: return .profile.withRenderingMode(.alwaysTemplate)
      }
   }
   
   private var toTabTitle: String {
      switch self {
      case .home: return "마이슐랭 지도"
      case .writePost: return "마이슐랭 작성"
      case .profile: return "프로필"
      }
   }
   
   var toTabbarItem: UITabBarItem {
      return .init(title: toTabTitle, image: toIcon, tag: rawValue)
   }
   
   var toViewController: UIViewController {
      switch self {
      case .home:
         let vc = HomeVC()
         vc.reactor = HomeReactor(MockPostUsecase(repository: MockPostRepository()))
         vc.tabBarItem = toTabbarItem
         return UINavigationController(rootViewController: vc)
      case .writePost:
         let vc = WriteMyBestVC()
         vc.reactor = WriteMyBestReactor(
            searchUsecase: SearchUsecase(searchRepository: SearchRepository()),
            postUsecase: MockPostUsecase(repository: MockPostRepository()),
            userUsecase: MockUserUsecase(repository: MockUserRepository())
         )
         vc.tabBarItem = toTabbarItem
         return vc
      case .profile:
         let vc = MeProfileVC()
         vc.reactor = MeProfileReactor(MockUserUsecase(repository: MockUserRepository()))
         vc.tabBarItem = toTabbarItem
         return UINavigationController(rootViewController: vc)
      }
   }
}

final class MainTabbarController: UITabBarController {
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
      setTabbar()
   }
   
   private func setTabbar() {
      let appearance = UITabBarAppearance()
      appearance.backgroundColor = .grayXs
      tabBar.standardAppearance = appearance
      
      tabBar.unselectedItemTintColor = .grayMd
      tabBar.tintColor = .black
      tabBar.backgroundColor = .white
      viewControllers = TabPage.allCases.map(\.toViewController)
   }
}
