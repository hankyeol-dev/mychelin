// hankyeol-dev. Map

import UIKit
import CoreLocation
import CommonUI
import NMapsMap
import SnapKit
import RxSwift
import ReactorKit

public final class NMapVC: BaseVC {
   private let disposeBag: DisposeBag = .init()
   private let locationManager: CLLocationManager = .init().then {
      $0.requestWhenInUseAuthorization()
      $0.desiredAccuracy = kCLLocationAccuracyBest
   }
   public let mapView: NMFMapView = .init()
   public let userLocationButton: UserLocationButton = .init()
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      locationManager.delegate = self
      mapView.addCameraDelegate(delegate: self)
      self.locationManagerDidChangeAuthorization(locationManager)
      
      userLocationButton.rx.tap
         .debug("tap")
         .bind(with: self) { vc, _ in
            vc.locationManagerDidChangeAuthorization(vc.locationManager)
         }.disposed(by: disposeBag)
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(mapView, userLocationButton)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      mapView.snp.makeConstraints { make in
         make.edges.equalTo(view.safeAreaLayoutGuide)
      }
      userLocationButton.snp.makeConstraints { make in
         make.size.equalTo(40.0)
         make.bottom.trailing.equalToSuperview().inset(20.0)
      }
   }
}

extension NMapVC: CLLocationManagerDelegate {
   public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      let status = manager.authorizationStatus
      if status == .denied || status == .notDetermined {
         manager.requestWhenInUseAuthorization()
      }
      if status == .authorizedAlways || status == .authorizedWhenInUse {
         manager.startUpdatingLocation()
         guard let location = manager.location?.coordinate else { return }
         moveToLocation(.init(lat: location.latitude, lng: location.longitude))
      }
   }
}

extension NMapVC: NMFMapViewCameraDelegate {
   public func moveToLocation(_ location: NMGLatLng) {
      let camera = NMFCameraUpdate(scrollTo: location)
      camera.animation = .easeIn
      mapView.moveCamera(camera)
   }
   
   public func mapViewCameraIdle(_ mapView: NMFMapView) {
   }
}
