// hankyeol-dev. Data

import Foundation
import Domain
import Moya

public enum AuthRouter {
   case validEmail(ValidationEmailInputType)
   case join(JoinInputType)
   case login(LoginInputType)
   case refreshToken(refreshToken: String)
}

extension AuthRouter: RouterType {
   public var path: String {
      switch self {
      case .validEmail: return "/users/validation/email"
      case .join: return "/users/join"
      case .login: return "/users/login"
      case .refreshToken: return "/auth/refresh"
      }
   }
   
   public var method: Moya.Method {
      switch self {
      case .validEmail, .join, .login:
            return .post
      case .refreshToken:
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
         let fields: [String: String] = [
            headerConfig.contentKey.rawValue: config.contentJson
         ]
         return generateHeaderFields(fields)
      case .join, .login:
         let fields: [String: String] = [
            headerConfig.productIdKey.rawValue: config.productId,
            headerConfig.contentKey.rawValue: config.contentJson
         ]
         return generateHeaderFields(fields)
      case let .refreshToken(refreshToken):
         let fields: [String: String] = [
            headerConfig.productIdKey.rawValue: config.productId,
            headerConfig.refreshTokenKey.rawValue: refreshToken,
            headerConfig.contentKey.rawValue: config.contentJson
         ]
         return generateHeaderFields(fields)
      }
   }
}
