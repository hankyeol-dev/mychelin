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
