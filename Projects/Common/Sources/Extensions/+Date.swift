
import Foundation

public extension Date {
   func formatTest() -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      return formatter.string(from: .now)
   }
}
