// hankyeol-dev. Home

import Foundation
import ReactorKit
import Domain

public final class HomeReactor: Reactor {
   private let disposeBag = DisposeBag()
   public var initialState: State = .init()
   
   public struct State {
      var initialLat: Double = 37.47748592701913
      var initialLng: Double = 126.96302796498439
      
      var curLat: Double = 0.0
      var curLng: Double = 0.0
   }
   public enum Action {
      case switchLocation(lat: Double, lng: Double)
   }
   public enum Mutation {
      case switchLocation(lat: Double, lng: Double)
   }
   
   public init() {}
}

extension HomeReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case let .switchLocation(lat, lng):
         return .just(.switchLocation(lat: lat, lng: lng))
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      switch mutation {
      case let .switchLocation(lat, lng):
         newState.curLat = lat
         newState.curLng = lng
      }
      return newState
   }
}
