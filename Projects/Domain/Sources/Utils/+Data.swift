// hankyeol-dev. Domain

import Foundation

extension Data {
   public mutating func appendString(_ content: String) {
      if let data = content.data(using: .utf8) {
         self.append(data)
      }
   }
}
