// hankyeol-dev. CommonUI

import UIKit
import Domain

extension FoodCategories {
   public var toIcons: UIImage {
      switch self {
      case .beer: return UIImage(resource: .beer)
      case .bingsu: return UIImage(resource: .bingsu)
      case .boong: return UIImage(resource: .boong)
      case .bread: return UIImage(resource: .bread)
      case .bunsik: return UIImage(resource: .bunsik)
      case .burger: return UIImage(resource: .burger)
      case .chicken: return UIImage(resource: .chicken)
      case .chinese: return UIImage(resource: .chinese)
      case .coffee: return UIImage(resource: .coffee)
      case .cutlet: return UIImage(resource: .cutlet)
      case .dessert: return UIImage(resource: .dessert)
      case .etc: return UIImage(resource: .etc)
      case .fine: return UIImage(resource: .fine)
      case .koreanBbq: return UIImage(resource: .koreanBbq)
      case .korean: return UIImage(resource: .korean)
      case .mexican: return UIImage(resource: .mexican)
      case .pizza: return UIImage(resource: .pizza)
      case .ramen: return UIImage(resource: .ramen)
      case .salad: return UIImage(resource: .salad)
      case .sandwich: return UIImage(resource: .sandwich)
      case .sushi: return UIImage(resource: .sushi)
      case .tteok: return UIImage(resource: .tteok)
      case .western: return UIImage(resource: .western)
      }
   }
   
   public static func toShuffled(_ prefix: FoodCategories) -> [Self] {
      let shuffled = Self.allCases.filter({ $0 != prefix }).shuffled()
      var newList: [Self] = []
      newList.append(prefix)
      newList.append(contentsOf: shuffled)
      return newList
   }
}
