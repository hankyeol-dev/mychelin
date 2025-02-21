// hankyeol-dev. Home

import Foundation
import ReactorKit
import Domain
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
      var curLocation: (Double, Double) = (0.0, 0.0)
      var postList: GetPostListVO = .init(data: [])
      var tappedPost: GetPostVO?
      var next: String = ""
      var errorMessage: String? = nil
   }
   public enum Action {
      case didLoad
      case switchLocation(lat: Double, lng: Double)
      case moveToInitialLocation
      case tapPostMarker(GetPostVO?)
   }
   public enum Mutation {
      case fetchLocationPosts(Result<GetPostListVO, CommonError>)
      case switchLocation(lat: Double, lng: Double)
      case setTappedPost(GetPostVO)
      case resetTappedPost
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
         let list = postUsecase.getPosts(query: .init(next: currentState.next, category: ""))
         return .just(.fetchLocationPosts(list))
      case let .switchLocation(lat, lng):
         return .just(.switchLocation(lat: lat, lng: lng))
      case .moveToInitialLocation:
         let location = getCurrentLocation()
         return .just(.switchLocation(lat: location.0, lng: location.1))
      case let .tapPostMarker(post):
         guard let post else { return .just(.resetTappedPost) }
         if let curPost = currentState.tappedPost {
            if curPost.postId == post.postId {
               return .just(.resetTappedPost)
            } else {
               return .just(.setTappedPost(post))
            }
         } else {
            return .just(.setTappedPost(post))
         }
      }
   }
   
   public func reduce(state: State, mutation: Mutation) -> State {
      var newState = state
      switch mutation {
      case let .switchLocation(lat, lng):
         newState.curLocation = (lat, lng)
      case let .fetchLocationPosts(result):
         switch result {
         case let .success(list):
            newState.postList = list
         case let .failure(error):
            newState.errorMessage = error.toMessage
         }
      case let .setTappedPost(post):
         newState.tappedPost = post
      case .resetTappedPost:
         newState.tappedPost = nil
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
         let lat = manager.location?.coordinate.latitude ?? 0.0
         let lng = manager.location?.coordinate.longitude ?? 0.0
         self.action.onNext(.switchLocation(lat: lat, lng: lng))
      }
   }
   
   private func getCurrentLocation() -> (Double, Double) {
      let lat = locationManager.location?.coordinate.latitude ?? 0.0
      let lng = locationManager.location?.coordinate.longitude ?? 0.0
      return (lat, lng)
   }
}
