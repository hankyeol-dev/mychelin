// hankyeol-dev. Data

import Foundation
import Moya
import Domain

public enum NaverSearchRouter {
   case search(query: String)
}

extension NaverSearchRouter: TargetType {
   public var baseURL: URL { return .init(string: env.searchBaseURL)! }
   public var path: String { return "" }
   public var method: Moya.Method { return .get }
   public var task: Moya.Task {
      switch self {
      case let .search(query):
         let queryString: [String: Any] = [
            "query": query,
            "display": 5
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
