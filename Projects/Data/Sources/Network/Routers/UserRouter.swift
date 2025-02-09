// hankyeol-dev. Data

import Foundation
import Domain
import Moya

public enum UserRouter {
   case me
   case meEdit(input: ProfileEditInputType)
   case meProfileImageEdit(input: ProfileImageInputType)
   case other(userId: String)
   case search(nick: String)
   case follow(userId: String)
   case unFollow(userId: String)
}

extension UserRouter: RouterType {
   public var path: String {
      switch self {
      case .me, .meEdit, .meProfileImageEdit: return "/users/me/profile"
      case .other(let userId): return "/users/\(userId)/profile"
      case .search: return "/users/search"
      case let .follow(userId), let .unFollow(userId): return "/follow/\(userId)"
      }
   }
   
   public var method: Moya.Method {
      switch self {
      case .me, .other, .search: return .get
      case .follow: return .post
      case .unFollow: return .delete
      case .meEdit, .meProfileImageEdit: return .put
      }
   }
   
   public var task: Moya.Task {
      switch self {
      case let .meEdit(input):
         let body = taskMapper(input)
         return .requestParameters(parameters: body, encoding: JSONEncoding.default)
      case let .meProfileImageEdit(input):
         let profile = [MultipartFormData(provider: .data(input.profile), name: "profile")]
         return .uploadMultipart(profile)
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

public enum MockUserRouter {
   case me
   case other(userId: String)
}

extension MockUserRouter: RouterProtocol {
   public var path: String {
      switch self {
      case .me: "/users/me/profile"
      case .other(let userId): "/users/\(userId)/profile"
      }
   }
   
   public var method: NetworkMethod { return .GET }
   
   public var parameters: [URLQueryItem]? { return nil }
   
   public var headers: [String : String] {
      return setHeader(.request, needToken: true, needProductId: true)
   }
   
   public var body: Data? { return nil }
}
