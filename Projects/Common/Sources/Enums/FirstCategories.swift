// hankyeol-dev. Common

import Foundation

public enum FirstCategories: CaseIterable {
   case restaurant, cafe, pub, consert, festival, sports, store, etc
   
   public var toKorean: String {
      switch self {
      case .restaurant: "음식점"
      case .cafe: "카페"
      case .pub: "술집"
      case .consert: "콘서트/공연"
      case .festival: "축제"
      case .sports: "스포츠"
      case .store: "가게(팝업)"
      case .etc: "기타"
      }
   }
}
