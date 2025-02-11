// hankyeol-dev. CommonUI

import UIKit
import PhotosUI
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
      setViews()
   }
   
   open func setSubviews() {}
   open func setLayouts() {}
   open func setViews() {}
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

public extension BaseVC {
   func loadImagesFromLibrary(from results: [PHPickerResult]) async -> [Data] {
      await withTaskGroup(of: Data?.self) { [weak self] taskGroup in
         guard let self else { return [] }
         for result in results {
            taskGroup.addTask {
               if let image = await self.loadImage(for: result) {
                  return image
               } else {
                  return nil
               }
            }
         }
         
         var images: [Data] = []
         for await image in taskGroup {
            if let image {
               images.append(image)
            }
         }
         return images
      }
   }
      
   func loadImage(for result: PHPickerResult) async -> Data? {
      return await withCheckedContinuation { continuation in
         if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
               if let image = image as? UIImage {
                  let data = image.downscaleTOjpegData(maxBytes: 1_000_000)
                  continuation.resume(returning: data)
               }
            }
         }
      }
   }
}
