// hankyeol-dev. Post

import Foundation
import ReactorKit
import Domain
import Data
import CommonUI

public final class WriteMyBestReactor: Reactor {
   private let disposeBage: DisposeBag = .init()
   private let searchUsecase: SearchUsecaseType = SearchUsecase(searchRepository: SearchRepository())
   
   public var initialState: State
   
   public struct State {
      var userNickname: String = ""
      var selectedFoodCategory: FoodCategories
      var searchSpotLocation: [NaverSearchVO] = []
      var selectedSpotLocation: NaverSearchVO?
   }
   
   public enum Action {
      case didLoad
      case updateFoodCategory(FoodCategories)
      case searchSpotLocation(query: String)
      case selectSpotLocation(NaverSearchVO?)
   }
   
   public enum Mutation {
      case setUsername
      case updateFoodCategory(FoodCategories)
      case searchSpotLocation(Result<[NaverSearchVO], NetworkErrors>)
      case setSpotLocation(NaverSearchVO?)
   }
   
   public init() {
      self.initialState = .init(
         selectedFoodCategory: FoodCategories.allCases.randomElement() ?? .etc
      )
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
         } else {
            newState.selectedSpotLocation = nil
         }
      }
      return newState
   }
}
