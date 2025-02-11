// hankyeol-dev. Data

import Foundation
import Domain

public struct SearchQueryType {
   public let next: String
   public let limit: Int = 10
   public let category: String
   public let hashTag: String
}

public struct SearchGEOQueryType {
   public let category: String
   public let longitude: Double
   public let latitude: Double
   public let maxDistance: Int
   public let orderBy: SearchOrderBy
   public let sortBy: SearchSortBy
   
   public init(
      category: String,
      longitude: Double,
      latitude: Double,
      maxDistance: Int = 200,
      orderBy: SearchOrderBy = .distance,
      sortBy: SearchSortBy = .desc
   ) {
      self.category = category
      self.longitude = longitude
      self.latitude = latitude
      self.maxDistance = maxDistance
      self.orderBy = orderBy
      self.sortBy = sortBy
   }
}

public enum SearchOrderBy: String {
   case distance
   case createdAt
}

public enum SearchSortBy: String {
   case asc, desc
}

public struct GEOLocation: Codable {
   public let longitude: Double
   public let latitude: Double
}


/// output
public struct SearchGEOOutputType: Decodable {
   public let data: [PostOutputType]
   
   enum CodingKeys: String, CodingKey {
      case data
   }
   
   var toGetPostListVO: GetPostListVO {
      return .init(data: data.map({ $0.toGetPostVO }))
   }
}
