// hankyeol-dev. Data

import Foundation
import Domain
import Moya

public protocol RouterType: TargetType {}

public extension RouterType {
   var baseURL: URL { .init(string: env.baseURL)! }
   var validationType: ValidationType { .successCodes }
   
   private func baseHeaderFields(_ needToken: Bool, _ contentType: ContentType) -> [String: String] {
      var baseHeaders = [headerConfig.secretKey.rawValue: headerConfigValue.secret.rawValue]
      if needToken {
         baseHeaders[headerConfig.authKey.rawValue] = UserDefaultsProvider.shared.getStringValue(.accessToken)
      }
      baseHeaders[headerConfig.contentKey.rawValue] = contentType == .base
      ? headerConfigValue.contentJson.rawValue
      : headerConfigValue.contentMultipart.rawValue
      
      return baseHeaders
   }
   
   func generateHeaderFields(_ needToken: Bool,
                             _ contentType: ContentType = .base,
                             _ fields: [String: String]) -> [String: String] {
      var base = baseHeaderFields(needToken, contentType)
      for (key, value) in fields { base[key] = value }
      return base
   }
   
   func taskMapper(_ inputType: Encodable) -> [String: Any] {
      let encoder = JSONEncoder()
      guard let encoded = try? encoder.encode(inputType) else { return [:] }
      guard let converted = try? JSONSerialization.jsonObject(with: encoded) as? [String : Any] else {
         return [:]
      }
      return converted
   }
}

public enum ContentType {
   case base
   case multipart
}
