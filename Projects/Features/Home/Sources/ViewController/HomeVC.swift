// hankyeol-dev. Home

import UIKit
import CommonUI
import NMapsMap
import ReactorKit
import Then
import SnapKit
import Domain

public final class HomeVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   
   private let locationManager: CLLocationManager = .init().then {
      $0.requestWhenInUseAuthorization()
      $0.desiredAccuracy = kCLLocationAccuracyBest
   }
   public let mapView: NMFMapView = .init().then {
      $0.positionMode = .normal
      $0.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)
      $0.minZoomLevel = 12.0
      $0.maxZoomLevel = 18.0
      $0.zoomLevel = 15.0
   }
   public let reloadBtn: ReloadButton = .init()
   private let userLocationButton: UserLocationButton = .init()
   private let bottomSheet: CustomBottomSheet = .init()
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      locationManager.delegate = self
      mapView.addCameraDelegate(delegate: self)
      self.locationManagerDidChangeAuthorization(locationManager)
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(mapView, userLocationButton, bottomSheet)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      mapView.snp.makeConstraints { make in
         make.edges.equalTo(view.safeAreaLayoutGuide)
      }
      userLocationButton.snp.makeConstraints { make in
         make.size.equalTo(30.0)
         make.trailing.equalToSuperview().inset(20.0)
         make.bottom.equalToSuperview().inset(100.0)
      }
      bottomSheet.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }
   }
}

extension HomeVC: View {
   public func bind(reactor: HomeReactor) {
      bindAction(reactor: reactor)
      bindState(reactor: reactor)
   }
   private func bindAction(reactor: HomeReactor) {
      reloadBtn.rx.tap
         .compactMap({ [weak self] in
            guard let self else { return nil }
            return Reactor.Action.switchLocation(lat: mapView.latitude, lng: mapView.longitude)
         })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
      
      userLocationButton.rx.tap
         .debug()
         .map({ Reactor.Action.moveToInitialLocation })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
   }
   private func bindState(reactor: HomeReactor) {
      reactor.state.map(\.postList)
         .bind(with: self) { vc, data in
            vc.bottomSheet.setInnerview(data.data)
         }.disposed(by: disposeBag)
         
      reactor.state.map(\.curLocation)
         .skip(1)
         .bind(with: self) { vc, loc in
            vc.moveToLocation(.init(lat: loc.0, lng: loc.1))
            vc.hideReloadBtn()
         }.disposed(by: disposeBag)
      
      reactor.state.map(\.postList)
         .bind(with: self) { vc, list in
            if !list.data.isEmpty {
               list.data.forEach {
                  let marker = NMFMarker(position: .init(lat: $0.postLat, lng: $0.postLng), iconImage: .init(image: .pin))
                  marker.mapView = vc.mapView
               }
            }
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
      if let distance = locationManager.location?.distance(
         from: .init(latitude: mapView.latitude,
                     longitude: mapView.longitude)),
         distance > 300 {
         displayReloadBtn()
      }
   }
   
   public func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
      hideReloadBtn()
   }
   
   private func displayReloadBtn() {
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
