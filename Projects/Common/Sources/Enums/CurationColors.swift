// hankyeol-dev. Common

import UIKit

public enum CurationColors: Int, CaseIterable {
   case blue, indigo, grape, lime, yellow, pink, red, orange
   
   public var toColor: UIColor {
      switch self {
      case .blue: return UIColor(resource: .cBlue)
      case .indigo: return UIColor(resource: .cIndigo)
      case .grape: return UIColor(resource: .cGrape)
      case .lime: return UIColor(resource: .cLime)
      case .yellow: return UIColor(resource: .cYellow)
      case .pink: return UIColor(resource: .cPink)
      case .red: return UIColor(resource: .cRed)
      case .orange: return UIColor(resource: .cOrange)
      }
   }
}
