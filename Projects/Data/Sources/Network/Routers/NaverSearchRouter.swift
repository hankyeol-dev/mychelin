// hankyeol-dev. Data

import Foundation
import Moya
import Domain

public enum NaverSearchRouter {
   case search(query: String, start: Int)
}

extension NaverSearchRouter: TargetType {
   public var baseURL: URL { return .init(string: env.searchBaseURL)! }
   public var path: String { return "" }
   public var method: Moya.Method { return .get }
   public var task: Moya.Task {
      switch self {
      case let .search(query, start):
         let queryString: [String: Any] = [
            "query": query,
            "display": 5,
            "start": start
         ]
         return .requestParameters(parameters: queryString, encoding: URLEncoding.queryString)
      }
   }
   public var headers: [String : String]? {
      return [
         "X-Naver-Client-Id": nSearchConfig.clientId.rawValue,
         "X-Naver-Client-Secret": nSearchConfig.clientSecret.rawValue
      ]
   }
   
   private func toPercentEncoding(_ query: String) -> String {
      return query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
   }
}

public enum KSearchRouter {
   case kSearch(query: String)
}

extension KSearchRouter: RouterProtocol {
   public var baseURL: String {
      return env.KSearchConfig.baseurl.rawValue
   }
   public var path: String {
      return ""
   }
   
   public var method: NetworkMethod {
      return .GET
   }
   
   public var parameters: [URLQueryItem]? {
      switch self {
      case let .kSearch(query):
         return [
            .init(name: "query", value: query),
            .init(name: "size", value: "10")
         ]
      }
   }
   
   public var headers: [String : String] {
      return [
         "Authorization": env.KSearchConfig.authKey.rawValue,
         "Content-Type": "application/json;charset=UTF-8"
      ]
   }
   
   public var body: Data? {
      return nil
   }
}
