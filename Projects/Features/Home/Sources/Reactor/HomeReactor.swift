// hankyeol-dev. Home

import Foundation
import ReactorKit
import Domain
import Data
import CoreLocation

public final class HomeReactor: NSObject, Reactor {
   private let disposeBag = DisposeBag()
   private let locationManager: CLLocationManager = .init().then {
      $0.requestWhenInUseAuthorization()
      $0.desiredAccuracy = kCLLocationAccuracyBest
   }
   private let postUsecase: MockPostUsecaseType
   
   public var initialState: State = .init()
   
   public struct State {
      var initialLat: Double = 0.0
      var initialLng: Double = 0.0
      
      var curLocation: (Double, Double) = (0.0, 0.0)
      
      var postList: GetPostListVO = .init(data: [])
   }
   public enum Action {
      case didLoad
      case switchLocation(lat: Double, lng: Double)
      case moveToInitialLocation
   }
   public enum Mutation {
      case fetchLocationPosts
      case switchLocation(lat: Double, lng: Double)
   }
   
   public init(_ postUsecase: MockPostUsecaseType) {
      self.postUsecase = postUsecase
      
      super.init()
      locationManager.delegate = self
      self.locationManagerDidChangeAuthorization(locationManager)
   }
}

extension HomeReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .didLoad:
         return .just(.fetchLocationPosts)
      case let .switchLocation(lat, lng):
         return .just(.switchLocation(lat: lat, lng: lng))
      case .moveToInitialLocation:
         return .just(.switchLocation(lat: initialState.initialLat, lng: initialState.initialLng))
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      switch mutation {
      case let .switchLocation(lat, lng):
         newState.curLocation = (lat, lng)
      case .fetchLocationPosts:
         newState.postList = .init(data: [MockPost1, MockPost2, MockPost3, MockPost4, MockPost5])
      }
      return newState
   }
}

extension HomeReactor: CLLocationManagerDelegate {
   public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      let status = manager.authorizationStatus
      if status == .denied || status == .notDetermined {
         manager.requestWhenInUseAuthorization()
      }
      if status == .authorizedAlways || status == .authorizedWhenInUse {
         manager.startUpdatingLocation()
         initialState.initialLat = manager.location?.coordinate.latitude ?? 0.0
      }
   }
}
