// hankyeol-dev. Domain

import Foundation

@frozen
public enum CommonError: Error {
   case error(message: String)
   
   public var toMessage: String {
      switch self {
      case let .error(message): return message
      }
   }
}
