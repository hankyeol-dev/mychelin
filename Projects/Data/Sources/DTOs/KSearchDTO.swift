// hankyeol-dev. Data

import Foundation
import Domain

public struct KSearchOutput: Decodable {
   public let documents: [KSearchItem]
   
   public struct KSearchItem: Decodable {
      let address_name: String
      let x: String
      let y: String
      let place_name: String
      
      public var toVO: KSearchVO.kSearchDocument {
         return .init(address: address_name, place: place_name, x: x, y: y)
      }
   }
   
   public var toVO: KSearchVO {
      return .init(documents: documents.map({ $0.toVO }))
   }
}
