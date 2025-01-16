// hankyeol-dev. Data

import Foundation
import Domain

public struct NaverSearchOutput: Decodable {
   public let items: [NaverSearchItem]
}

public struct NaverSearchItem: Decodable {
   public let title: String
   public let roadAddress: String
   public let mapx: String
   public let mapy: String
   
   var toHTMLEncodedString: String {
      guard let data = title.data(using: .utf8) else { return title }
      
      let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
         .documentType: NSAttributedString.DocumentType.html,
         .characterEncoding: String.Encoding.utf8.rawValue
      ]
      guard let attributed = try? NSAttributedString(data: data,
                                                     options: options,
                                                     documentAttributes: nil)
      else { return title }
      return attributed.string
   }
   
   var toVO: NaverSearchVO {
      return .init(title: toHTMLEncodedString,
                   roadAddress: roadAddress,
                   mapx: Int(mapx) ?? 0,
                   mapy: Int(mapy) ?? 0)
   }
}
