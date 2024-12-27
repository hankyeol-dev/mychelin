// hankyeol-dev. Data

import Foundation
import Moya

public enum UserRouter {
   case me
   case meEdit
   case other(userId: String)
   case search(nick: String)
}

extension UserRouter: RouterType {
   public var path: String {
      switch self {
      case .me, .meEdit: return "/users/me/profile"
      case .other(let userId): return "/users/\(userId)/profile"
      case .search: return "/users/search"
      }
   }
   
   public var method: Moya.Method {
      switch self {
      case .me, .other, .search: return .get
      case .meEdit: return .put
      }
   }
   
   public var task: Moya.Task {
      switch self {
      case let .search(nick):
         return .requestParameters(parameters: ["nick": nick], encoding: URLEncoding.queryString)
      default:
         return .requestPlain
      }
   }
   
   public var headers: [String : String]? {
      let fields = [
         headerConfig.productIdKey.rawValue: headerConfigValue.productId.rawValue
      ]
      return generateHeaderFields(true, .base, fields)
   }
}
