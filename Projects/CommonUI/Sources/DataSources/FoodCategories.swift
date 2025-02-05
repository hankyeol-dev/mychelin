// hankyeol-dev. CommonUI

import UIKit

@frozen
public enum FoodCategories: String, CaseIterable {
   case beer = "맥주"
   case bingsu = "빙수"
   case boong = "붕어빵/길거리 음식"
   case bread = "빵"
   case bunsik = "기타 분식"
   case burger = "버거"
   case chicken = "치킨"
   case chinese = "중식"
   case coffee = "커피"
   case cutlet = "돈까스"
   case dessert = "디저트"
   case etc = "기타 음식"
   case fine = "파인다이닝"
   case koreanBbq = "삼겹살/곱창"
   case korean = "한식"
   case mexican = "멕시코 음식"
   case pizza = "피자"
   case ramen = "라면"
   case salad = "샐러드"
   case sandwich = "샌드위치"
   case sushi = "스시/일식"
   case tteok = "떡볶이"
   case western = "서양식"
   
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
}
