// hankyeol-dev.

import UIKit
import CommonUI
import Domain
import Data
import Profile

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   
   var window: UIWindow?
   var errorWindow: UIWindow?
   
   var isLoggedIn: Bool = UserDefaultsProvider.shared.getBoolValue()
   var coordinator: AppCoordinator!
   private let networkMonitorService: NetworkMonitorService = .shared
   
   func scene(
      _ scene: UIScene,
      willConnectTo session: UISceneSession,
      options connectionOptions: UIScene.ConnectionOptions
   ) {
      guard let scene = (scene as? UIWindowScene) else { return }
      
      networkMonitorService.startMonitor { [weak self] isConnected in
         guard let self else { return }
         switch isConnected {
         case true:
            hideNetworkDisconnectedView()
            window = UIWindow(windowScene: scene)
            window?.rootViewController = MainTabbarController()
            window?.makeKeyAndVisible()
         case false:
            displayNetworkDisconnectedView(scene)
         }
      }
   }
   
   func sceneDidDisconnect(_ scene: UIScene) {
      networkMonitorService.stopMonitor()
   }
}

extension SceneDelegate {
   private func displayNetworkDisconnectedView(_ scene: UIScene) {
      guard let scene = (scene as? UIWindowScene) else { return }
      let newWindow = UIWindow(windowScene: scene)
      newWindow.windowLevel = .statusBar
      newWindow.makeKeyAndVisible()
      
      let errorView = NetworkDisconnectView(frame: newWindow.bounds)
      newWindow.addSubview(errorView)
      errorWindow = newWindow
   }
   
   private func hideNetworkDisconnectedView() {
      errorWindow?.resignKey()
      errorWindow?.isHidden = true
      errorWindow = nil
   }
}

fileprivate final class NetworkDisconnectView: BaseView {
   private let errorImage: UIImageView = .init().then {
      $0.image = UIImage(systemName: "wifi.exclamationmark")?.withRenderingMode(.alwaysTemplate)
      $0.tintColor = .errors
   }
   private let errorLabel: BaseLabel = .init(.init(text: "와이파이 또는 셀룰러 네트워크 연결을 확인해주세요.",
                                                   style: .subtitle,
                                                   color: .errors)).then {
      $0.numberOfLines = 0
   }
   
   override func setView() {
      super.setView()
      backgroundColor = .white
      addSubviews(errorImage, errorLabel)
      errorImage.snp.makeConstraints { make in
         make.center.equalToSuperview()
         make.size.equalTo(80.0)
      }
      errorLabel.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.top.equalTo(errorImage.snp.bottom).offset(20.0)
      }
   }
}
