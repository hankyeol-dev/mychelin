// hankyeol-dev. Common

import Foundation

public extension String {
   func toISO860() -> Date {
      let target: Self = String(self.split(separator: ".")[0]) + "Z"
      let formatter = ISO8601DateFormatter()
      formatter.timeZone = TimeZone(abbreviation: "KST")
      formatter.formatOptions = [.withInternetDateTime]
      return formatter.date(from: target) ?? Date()
   }
   
   func toSnakeCategory() -> Self {
      let splitWhitespace = self.split(separator: " ")
      return splitWhitespace.joined(separator: "_")
   }
}
