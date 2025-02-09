// hankyeol-dev. Post

import Foundation
import ReactorKit
import Domain
import Data
import CommonUI

public final class WriteMyBestReactor: Reactor {
   private let disposeBage: DisposeBag = .init()
   private let searchUsecase: SearchUsecaseType
   
   public var initialState: State
   
   public struct State {
      var userNickname: String = ""
      var selectedFoodCategory: FoodCategories
      var searchSpotLocation: [NaverSearchVO] = []
      var selectedSpotLocation: NaverSearchVO?
      var spotName: String = ""
      var spotRate: Double = 0.0
      var spotPhotos: [NSItemProvider] = []
      var isCanPost: Bool = false
   }
   
   public enum Action {
      case didLoad
      case updateFoodCategory(FoodCategories)
      case searchSpotLocation(query: String)
      case selectSpotLocation(NaverSearchVO?)
      case setRate(Double)
      case setPhotos([NSItemProvider])
      case removeFromPhotos(NSItemProvider)
   }
   
   public enum Mutation {
      case setUsername
      case updateFoodCategory(FoodCategories)
      case searchSpotLocation(Result<[NaverSearchVO], NetworkErrors>)
      case setSpotLocation(NaverSearchVO?)
      case setSpotRate(Double)
      case setPhotos([NSItemProvider])
      case removeFromPhotos(NSItemProvider)
   }
   
   public init(_ searchUsecase: SearchUsecaseType) {
      self.initialState = .init(
         selectedFoodCategory: FoodCategories.allCases.randomElement() ?? .etc
      )
      self.searchUsecase = searchUsecase
   }
}

extension WriteMyBestReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .didLoad:
         return .just(.setUsername)
      case let .updateFoodCategory(category):
         return .just(.updateFoodCategory(category))
      case let .searchSpotLocation(query):
         return searchUsecase.nLocationSearch(query: query, start: 1)
            .asObservable()
            .map({ .searchSpotLocation($0) })
      case let .selectSpotLocation(spot):
         return .just(.setSpotLocation(spot))
      case let .setRate(rate):
         return .just(.setSpotRate(rate))
      case let .setPhotos(items):
         return .just(.setPhotos(items))
      case let .removeFromPhotos(item):
         return .just(.removeFromPhotos(item))
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      switch mutation {
      case .setUsername:
         newState.userNickname = "최대6자까지할까"
      case let .updateFoodCategory(category):
         newState.selectedFoodCategory = category
      case let .searchSpotLocation(result):
         switch result {
         case let .success(output):
            newState.searchSpotLocation = output
         case .failure:
            newState.searchSpotLocation = []
         }
      case let .setSpotLocation(spot):
         if let spot {
            newState.selectedSpotLocation = spot
            newState.spotName = spot.title
         } else {
            newState.selectedSpotLocation = nil
         }
      case let .setSpotRate(rate):
         newState.spotRate = rate
      case let .setPhotos(items):
         if newState.spotPhotos.isEmpty {
            newState.spotPhotos = items
         } else {
            newState.spotPhotos.append(contentsOf: items)
         }
      case let .removeFromPhotos(item):
         if let index = newState.spotPhotos.firstIndex(of: item) {
            newState.spotPhotos.remove(at: index)
         }
      }
      return newState
   }
   
}
