// hankyeol-dev. Data

import Foundation

import Moya

public protocol RouterType: TargetType {}

public extension RouterType {
   var baseURL: URL { .init(string: DataConfiguration.baseURL)! }
   
   func baseHeaderFields() -> [String: String] {
      return [DataConfiguration.HeaderKeys.secretKey.rawValue: DataConfiguration.secret]
   }
   
   func generateHeaderFields(_ fields: [String: String]) -> [String: String] {
      var base = baseHeaderFields()
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
