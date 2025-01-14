// hankyeol-dev. Post

import Foundation
import MapKit
import Domain
import ReactorKit

public final class WritePostReactor: Reactor {
   private let disposeBag: DisposeBag = .init()
     
   public var initialState: State = .init()
   
   public struct State {
      var location: CLLocationCoordinate2D? = nil
      var address: String = ""
   }
   
   public enum Action {
      case didLoad(CLLocationCoordinate2D?, String)
   }
   
   public enum Mutation {
      case didLoad(CLLocationCoordinate2D?, String)
   }
}

extension WritePostReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case let .didLoad(location, address):
         return .just(.didLoad(location, address))
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      switch mutation {
      case let .didLoad(location, address):
         newState.location = location
         newState.address = address
      }
      return newState
   }
}
