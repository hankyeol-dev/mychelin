// hankyeol-dev. Domain

import Foundation
import MapKit
import CoreLocation
import RxSwift
import Then


public final class LocationService: NSObject {
   public static let shared: LocationService = .init()
   
   private let disposeBag: DisposeBag = .init()
   private let locationManager: CLLocationManager = .init().then {
      $0.desiredAccuracy = kCLLocationAccuracyBest
      $0.distanceFilter = kCLDistanceFilterNone
   }
   
   public let locationSubject: BehaviorSubject<CLLocationCoordinate2D> = .init(
      value: .init(latitude: env.defaultLat, longitude: env.defaultLon)
   )
   public let locationDong: BehaviorSubject<String> = .init(value: "")
   public let locationAddress: BehaviorSubject<String> = .init(value: "")
   
   private override init() {
      super.init()
      locationManager.delegate = self
   }
   
   public func startUpdateLocation(_ completionHanlder: @escaping () -> Void) {
      let status = locationManager.authorizationStatus
      if status == .notDetermined || status == .denied {
         locationManager.requestWhenInUseAuthorization()
      }
      if status == .authorizedAlways || status == .authorizedWhenInUse {
         completionHanlder()
      }
   }
      
   public func updateLocation(_ location: CLLocationCoordinate2D) {
      locationSubject.onNext(location)
      convertToAddress(location)
   }
   
   private func convertToAddress(_ coordinate: CLLocationCoordinate2D) {
      let geocoder = CLGeocoder()
      let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
      geocoder.reverseGeocodeLocation(location) { [weak self] placemark, error in
         guard error == nil else { return }
         guard let placemark = placemark?.first else { return }
         self?.locationDong.onNext("\(placemark.subLocality ?? "동 없음")")
         self?.locationAddress.onNext("\(placemark.locality ?? "") \(placemark.name ?? "")")
      }
   }
}

extension LocationService: CLLocationManagerDelegate {
   public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      let status = manager.authorizationStatus
      
      if status == .authorizedWhenInUse || status == .authorizedAlways {
         guard let location = manager.location else {
            print("no location")
            return
         }
         
         updateLocation(location.coordinate)
      }
   }
}
