// hankyeol-dev. Home

import UIKit
import CommonUI
import NMapsMap
import ReactorKit
import Then
import SnapKit

public final class HomeVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   
   private let locationManager: CLLocationManager = .init().then {
      $0.requestWhenInUseAuthorization()
      $0.desiredAccuracy = kCLLocationAccuracyBest
   }
   public let mapView: NMFMapView = .init().then {
      $0.positionMode = .normal
      $0.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)
      $0.zoomLevel = 15.0
   }
   public let reloadBtn: ReloadButton = .init()
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      locationManager.delegate = self
      mapView.addCameraDelegate(delegate: self)
      self.locationManagerDidChangeAuthorization(locationManager)
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubview(mapView)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      mapView.snp.makeConstraints { make in
         make.edges.equalTo(view.safeAreaLayoutGuide)
      }
   }
}

extension HomeVC: View {
   public func bind(reactor: HomeReactor) {
      bindAction(reactor: reactor)
      bindState(reactor: reactor)
   }
   private func bindAction(reactor: HomeReactor) {
      
   }
   private func bindState(reactor: HomeReactor) {
      Observable.just((reactor.initialState.initialLat, reactor.initialState.initialLng))
         .bind(with: self) { vc, loc in
            vc.moveToLocation(.init(lat: loc.0, lng: loc.1))
         }.disposed(by: disposeBag)
   }
}

extension HomeVC: CLLocationManagerDelegate {
   public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      let status = manager.authorizationStatus
      if status == .denied || status == .notDetermined {
         manager.requestWhenInUseAuthorization()
      }
      if status == .authorizedAlways || status == .authorizedWhenInUse {
         manager.startUpdatingLocation()
      }
   }
}

extension HomeVC: NMFMapViewCameraDelegate {
   private func moveToLocation(_ location: NMGLatLng) {
      let camera = NMFCameraUpdate(scrollTo: location)
      camera.animation = .easeIn
      mapView.moveCamera(camera)
   }
   
   public func mapViewCameraIdle(_ mapView: NMFMapView) {
      hideReloadBtn()
      if let distance = locationManager.location?.distance(
         from: .init(latitude: mapView.latitude,
                     longitude: mapView.longitude)),
         distance > 150 {
         displayReloadBtn()
      }
   }
   
   public func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
      hideReloadBtn()
   }
   
   private func displayReloadBtn() {
      hideReloadBtn()
      view.addSubview(reloadBtn)
      reloadBtn.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.top.equalTo(view.safeAreaLayoutGuide).inset(30.0)
         make.height.equalTo(40.0)
      }
   }
   
   private func hideReloadBtn() {
      reloadBtn.removeFromSuperview()
   }
}
