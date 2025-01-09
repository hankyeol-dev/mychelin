// hankyeol-dev. Post

import Foundation
import CoreLocation
import Domain
import ReactorKit

public final class WritePostMapReactor: Reactor {
   private let disposeBag: DisposeBag = .init()
   private let locationService: LocationService = .shared
   
   public var initialState: State = .init()
   public var oldLocation: CLLocationCoordinate2D?
   
   public struct State {
      var currentLocation: CLLocationCoordinate2D? = nil
      var currentAddress: String = ""
      var isTapNextButton: Bool = false
   }
   
   public enum Action {
      case didLoad
      case moveLocation(CLLocationCoordinate2D)
      case tapNextButton
   }
   
   public enum Mutation {
      case didLoad
      case updateLocation(CLLocationCoordinate2D)
      case tapNextButton
   }
}

extension WritePostMapReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .didLoad:
         locationService.startUpdateLocation {}
         return .just(.didLoad)
      case let .moveLocation(location):
         return .just(.updateLocation(location))
      case .tapNextButton:
         return .just(.tapNextButton)
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      
      switch mutation {
      case .didLoad:
         newState = setLocationState(newState)
      case let .updateLocation(location):
         locationService.updateLocation(location)
         newState = setLocationState(newState)
      case .tapNextButton:
         newState.isTapNextButton = true
      }
      
      return newState
   }
   
   private func setLocationState(_ state: State) -> State {
      var newState = state

      oldLocation = state.currentLocation
      
      locationService.locationSubject
         .subscribe { location in
            newState.currentLocation = location
         }.disposed(by: disposeBag)
      locationService.locationAddress
         .subscribe { address in
            newState.currentAddress = address
         }.disposed(by: disposeBag)
      
      return newState
   }
}
