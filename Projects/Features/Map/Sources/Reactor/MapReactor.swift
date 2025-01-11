// hankyeol-dev. Map

import Foundation
import CoreLocation

import ReactorKit
import Data
import Domain

public final class MapReactor: NSObject, Reactor {
   private let disposeBag: DisposeBag = .init()
   private let locationManager: CLLocationManager = .init().then {
      $0.desiredAccuracy = kCLLocationAccuracyBest
      $0.distanceFilter = kCLDistanceFilterNone
   }
   private let postUsecase: PostUsecaseType = PostUsecase(postRepository: PostRepository())
   
   public let initialState: State = .init()
   
   public enum DisplayType {
      case map
      case list
   }
   
   public struct State {
      var displayType: DisplayType = .map
      var currentLocation: CLLocationCoordinate2D? = nil
      var currentPosts: [GetPostVO] = []
   }
   
   public enum Action {
      case didLoad
      case fetchPosts(String, CLLocationCoordinate2D)
      case tapDisplayTypeButton
   }
   
   public enum Mutation {
      case didLoad
      case fetchPosts(Result<GetPostListVO, NetworkErrors>)
      case switchDisplayType
   }
}

extension MapReactor {
   public func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .didLoad:
         return .concat([.just(.didLoad)])
      case let .fetchPosts(cateogry, location):
         let query: GEOSearchQueryVO = .init(
            category: cateogry,
            longitude: location.longitude,
            latitude: location.latitude,
            maxDistance: 150)
         return postUsecase.getPosts(query: query)
            .asObservable()
            .map({ .fetchPosts($0) })
      case .tapDisplayTypeButton: return .just(.switchDisplayType)
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      switch mutation {
      case .didLoad:
         startUpdateLocation { [weak self] location in
            newState.currentLocation = location
            self?.action.onNext(.fetchPosts("", location))
         }
      case let .fetchPosts(result):
         switch result {
         case let .success(vo):
            newState.currentPosts = vo.data
         case let .failure(error):
            print(error)
         }
      case .switchDisplayType:
         newState.displayType = state.displayType == .map ? .list : .map
         if newState.displayType == .map {
            startUpdateLocation { location in
               newState.currentLocation = location
            }
         }
      }
      return newState
   }
}

extension MapReactor: CLLocationManagerDelegate {
   public func startUpdateLocation(_ handler: @escaping (CLLocationCoordinate2D) -> Void) {
      let status = locationManager.authorizationStatus
      if status == .notDetermined || status == .denied {
         locationManager.requestWhenInUseAuthorization()
      }
      if status == .authorizedAlways || status == .authorizedWhenInUse {
         if let location = locationManager.location?.coordinate {
            handler(location)
         }
      }
   }
}
