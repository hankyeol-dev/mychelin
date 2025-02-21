// hankyeol-dev. Post

import Foundation
import ReactorKit
import Domain
import CommonUI

public final class WriteMyBestReactor: Reactor {
   private let disposeBage: DisposeBag = .init()
   private let searchUsecase: SearchUsecaseType
   private let postUsecase: MockPostUsecaseType
   private let userUsecase: MockUserUsecaseType
   
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
      case setUsername(Result<MeProfileVO, CommonError>)
      case updateFoodCategory(FoodCategories)
      case searchSpotLocation(Result<[NaverSearchVO], NetworkErrors>)
      case setSpotLocation(NaverSearchVO?)
      case setSpotRate(Double)
      case setPhotos([NSItemProvider])
      case removeFromPhotos(NSItemProvider)
   }
   
   public init(
      searchUsecase: SearchUsecaseType,
      postUsecase: MockPostUsecaseType,
      userUsecase: MockUserUsecaseType
   ) {
      self.initialState = .init(
         selectedFoodCategory: FoodCategories.allCases.randomElement() ?? .etc
      )
      self.searchUsecase = searchUsecase
      self.postUsecase = postUsecase
      self.userUsecase = userUsecase
   }
}

extension WriteMyBestReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .didLoad:
         return .just(.setUsername(userUsecase.getMe()))
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
      case let .setUsername(profile):
         switch profile {
         case let .success(profile):
            newState.userNickname = profile.nick
         case .failure:
            newState.isCanPost = false
         }
      case let .updateFoodCategory(category):
         newState.selectedFoodCategory = category
         newState.isCanPost = validateCanPost()
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
            newState.isCanPost = validateCanPost()
         } else {
            newState.selectedSpotLocation = nil
         }
      case let .setSpotRate(rate):
         newState.spotRate = rate
         newState.isCanPost = validateCanPost()
      case let .setPhotos(items):
         if newState.spotPhotos.isEmpty {
            newState.spotPhotos = items
            newState.isCanPost = validateCanPost()
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
   
   private func validateCanPost() -> Bool {
      return !currentState.spotName.isEmpty
      && currentState.selectedSpotLocation != nil
      && currentState.spotRate != 0.0
   }
}
