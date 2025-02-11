// hankyeol-dev. Domain

import Foundation

@frozen
public enum FoodCategories: String, CaseIterable {
   case beer
   case bingsu
   case boong
   case bread
   case bunsik
   case burger
   case chicken
   case chinese
   case coffee
   case cutlet
   case dessert
   case etc
   case fine
   case koreanBbq
   case korean
   case mexican
   case pizza
   case ramen
   case salad
   case sandwich
   case sushi
   case tteok
   case western
   
   public var toCategory: String {
      switch self {
      case .beer: return "술"
      case .bingsu: return "빙수"
      case .boong: return "길거리 음식"
      case .bread: return "빵"
      case .bunsik: return "기타 분식"
      case .burger: return "버거"
      case .chicken: return "치킨"
      case .chinese: return "중식"
      case .coffee: return "커피"
      case .cutlet: return "돈까스"
      case .dessert: return "디저트"
      case .etc: return "기타 음식"
      case .fine: return "파인다이닝"
      case .koreanBbq: return "고기, 곱창"
      case .korean: return "한식"
      case .mexican: return "타코"
      case .pizza: return "피자"
      case .ramen: return "라면"
      case .salad: return "샐러드"
      case .sandwich: return "샌드위치"
      case .sushi: return "일식"
      case .tteok: return "떡볶이"
      case .western: return "서양식"
      }
   }
}
