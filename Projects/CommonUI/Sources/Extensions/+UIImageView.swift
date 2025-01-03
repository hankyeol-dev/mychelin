// hankyeol-dev. CommonUI

import UIKit
import Kingfisher
import Domain

public extension UIImageView {
   func setImage(_ urlString: String) {
      kf.indicatorType = .activity
      
      ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
         switch result {
         case let .success(output):
            DispatchQueue.main.async { [weak self] in
               guard let image = output.image else {
                  let requestURL = env.baseURL + "/" + urlString
                  guard let convertedURL = URL(string: requestURL) else { return }
                  let resource = KF.ImageResource(downloadURL: convertedURL, cacheKey: urlString)
                  KingfisherManager.shared.setImageRequestHeader()
                  self?.kf.setImage(with: resource, options: [
                     .transition(.fade(1.0))
                  ]) { [weak self] result in
                     switch result {
                     case let .success(retrived):
                        self?.image = retrived.image
                     case let .failure(error):
                        print("setImage error: ", error)
                        self?.image = UIImage(systemName: "star")
                     }
                  }
                  return
               }
               self?.image = image
            }
         
         case let .failure(error):
            print(error)
         }
      }
   }
}
