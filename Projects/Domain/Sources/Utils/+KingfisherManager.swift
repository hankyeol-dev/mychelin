// hankyeol-dev. Domain

import Foundation
import Kingfisher

public extension KingfisherManager {
   func setImageRequestHeader() {
      let modifier: AnyModifier = AnyModifier { request in
         var req = request
         req.setValue(headerConfigValue.productId.rawValue,
                      forHTTPHeaderField: headerConfig.productIdKey.rawValue)
         req.setValue(headerConfigValue.secret.rawValue,
                      forHTTPHeaderField: headerConfig.secretKey.rawValue)
         req.setValue(UserDefaultsProvider.shared.getStringValue(.accessToken),
                      forHTTPHeaderField: headerConfig.authKey.rawValue)
         return req
      }
      KingfisherManager.shared.defaultOptions = [
         .requestModifier(modifier)
      ]
   }
}
