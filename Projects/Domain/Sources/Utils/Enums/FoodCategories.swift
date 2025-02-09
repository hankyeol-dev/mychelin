// hankyeol-dev. Domain

import Foundation

@frozen
public enum FoodCategories: String, CaseIterable {
   case beer = "술"
   case bingsu = "빙수"
   case boong = "길거리 음식"
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
   case koreanBbq = "고기, 곱창"
   case korean = "한식"
   case mexican = "타코"
   case pizza = "피자"
   case ramen = "라면"
   case salad = "샐러드"
   case sandwich = "샌드위치"
   case sushi = "일식"
   case tteok = "떡볶이"
   case western = "서양식"
}
