// hankyeol-dev. Domain

import Foundation

public struct NaverSearchVO {
   public let title: String
   public let roadAddress: String
   public let mapx: Int
   public let mapy: Int
   
   public init(title: String, roadAddress: String, mapx: Int, mapy: Int) {
      self.title = title
      self.roadAddress = roadAddress
      self.mapx = mapx
      self.mapy = mapy
   }
}

public struct KSearchVO {
   public let documents: [kSearchDocument]
   
   public struct kSearchDocument {
      let address: String
      let place: String
      let x: String
      let y: String
      
      public init(address: String, place: String, x: String, y: String) {
         self.address = address
         self.place = place
         self.x = x
         self.y = y
      }
   }
   
   public init(documents: [kSearchDocument]) {
      self.documents = documents
   }
}
