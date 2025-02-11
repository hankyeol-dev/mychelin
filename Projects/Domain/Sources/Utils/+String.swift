// hankyeol-dev. Domain

import Foundation

public extension String {
   func mapToSnakecase() -> String {
      return self.split(separator: " ").joined(separator: "_")
   }
}
