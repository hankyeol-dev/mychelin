// hankyeol-dev. Data

import Foundation
import Moya

public enum AuthRouter {
   case validEmail(ValidationEmailInputType)
   case join(JoinInputType)
   case login(LoginInputType)
   case refreshToken(refreshToken: String)
   case withdraw
}

extension AuthRouter: RouterType {
   public var path: String {
      switch self {
      case .validEmail: return "/users/validation/email"
      case .join: return "/users/join"
      case .login: return "/users/login"
      case .refreshToken: return "/auth/refresh"
      case .withdraw: return "/users/withdraw"
      }
   }
   
   public var method: Moya.Method {
      switch self {
      case .validEmail, .join, .login:
            return .post
      case .refreshToken, .withdraw:
            return .get
      }
   }
   
   public var task: Moya.Task {
      switch self {
      case let .validEmail(input):
         let body = taskMapper(input)
         return .requestParameters(parameters: body, encoding: JSONEncoding.default)
      case let .join(input):
         let body = taskMapper(input)
         return .requestParameters(parameters: body, encoding: JSONEncoding.default)
      case let .login(input):
         let body = taskMapper(input)
         return .requestParameters(parameters: body, encoding: JSONEncoding.default)
      default:
         return .requestPlain
      }
   }
   
   public var headers: [String : String]? {
      switch self {
      case .validEmail:
         return generateHeaderFields(false, .base, [:])
      case .join, .login:
         let fields: [String: String] = [
            headerConfig.productIdKey.rawValue: headerConfigValue.productId.rawValue
         ]
         return generateHeaderFields(false, .base, fields)
      case let .refreshToken(refreshToken):
         let fields: [String: String] = [
            headerConfig.productIdKey.rawValue: headerConfigValue.productId.rawValue,
            headerConfig.refreshTokenKey.rawValue: refreshToken
         ]
         return generateHeaderFields(true, .base, fields)
      case .withdraw:
         let fields: [String: String] = [
            headerConfig.productIdKey.rawValue: headerConfigValue.productId.rawValue
         ]
         return generateHeaderFields(true, .base, fields)
      }
   }
}
