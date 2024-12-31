// hankyeol-dev. Data

import Foundation

public struct SearchQueryType {
   public let next: String
   public let limit: Int = 5
   public let category: String
   public let hashTag: String
}

public struct SearchGEOQueryType {
   public let category: String
   public let longitude: Double
   public let latitude: Double
   public let maxDistance: Int = 100
   public let orderBy: SearchOrderBy = .distance
   public let sortBy: SearchSortBy = .asc
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
