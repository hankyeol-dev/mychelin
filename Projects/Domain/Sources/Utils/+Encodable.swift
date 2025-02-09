// hankyeol-dev. Domain

import Foundation

extension Encodable {
   public var toJSON: Data? {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let json = try? encoder.encode(self)
      
      return json
   }
}
