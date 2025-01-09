// hankyeol-dev. Post

import Foundation
import MapKit
import Domain
import ReactorKit

public final class WritePostReactor: Reactor {
   private let disposeBag: DisposeBag = .init()
   private let locationService: LocationService = .shared
   
   public var initialState: State = .init()
   
   public struct State {
      var location: CLLocationCoordinate2D? = nil
      var address: String = ""
   }
   
   public enum Action {
      case didLoad
   }
   
   public enum Mutation {
      case didLoad
   }
}

extension WritePostReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .didLoad:
         return .just(.didLoad)
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      switch mutation {
      case .didLoad:
         locationService.locationSubject
            .subscribe { location in
               newState.location = location
            }.disposed(by: disposeBag)
         locationService.locationAddress
            .subscribe { address in
               newState.address = address
            }.disposed(by: disposeBag)
      }
      return newState
   }
}
