// hankyeol-dev. Data

import Foundation
import Domain
import Moya

public enum SearchRouter {
   case searchByHashTag(query: SearchQueryType)
   case searchByGeoLocation(query: SearchGEOQueryType)
}

extension SearchRouter: RouterType {
   public var path: String {
      switch self {
      case .searchByHashTag: return "/posts/hashtags"
      case .searchByGeoLocation: return "/posts/geolocation"
      }
   }
   
   public var method: Moya.Method {
      return .get
   }
   
   public var task: Moya.Task {
      switch self {
      case let .searchByHashTag(query):
         let queries: [String: String] = [
            "next": query.next.isEmpty ? "" : query.next,
            "limit": String(query.limit),
            "category": query.category.isEmpty ? "" : query.category,
            "hashTag": query.hashTag.isEmpty ? "" : query.hashTag
         ]
         return .requestParameters(parameters: queries, encoding: URLEncoding.queryString)
      case let .searchByGeoLocation(query):
         let queries: [String: String] = [
            "category": query.category.isEmpty ? "" : query.category,
            "longitude": String(query.longitude),
            "latitude": String(query.latitude),
            "maxDistance": String(query.maxDistance),
            "order_by": query.orderBy.rawValue,
            "sort_by": query.sortBy.rawValue
         ]
         return .requestParameters(parameters: queries, encoding: URLEncoding.queryString)
      }
   }
   
   public var headers: [String : String]? {
      let productIdFiels = [
         headerConfig.productIdKey.rawValue: headerConfigValue.productId.rawValue
      ]
      return generateHeaderFields(true, .base, productIdFiels)
   }
}
