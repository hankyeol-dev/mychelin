// hankyeol-dev. Post

import UIKit
import CoreLocation

import CommonUI

import NMapsMap
import RxCocoa
import ReactorKit
import SnapKit
import Then

public final class WritePostMapVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   private let locationManager: CLLocationManager = .init().then {
      $0.requestWhenInUseAuthorization()
      $0.desiredAccuracy = kCLLocationAccuracyBest
   }
   
   private let xButton: UIButton = .init().then {
      $0.setImage(.xmarkOutline, for: .normal)
      $0.tintColor = .grayLg
   }
   private let mapView: NMFMapView = .init().then {
      $0.allowsZooming = true
      $0.allowsScrolling = true
   }
   private let userLocationButton: UserLocationButton = .init()
   private let mapPin: UIImageView = .init().then {
      $0.image = .pin.withRenderingMode(.alwaysTemplate)
      $0.tintColor = .errors
   }
   private let locationBox: UIStackView = .init().then {
      $0.backgroundColor = .white
      $0.axis = .vertical
      $0.spacing = 10.0
      $0.distribution = .fillEqually
   }
   private let titleLabel: BaseLabel = .init(.init(text: "장소를 등록해주세요.", style: .title))
   private let addressBox: AddressBox = .init().then { $0.setBackground(.grayXs) }
   private let nextButton: RoundedButton = .init("위치 설정", backgroundColor: .greenMd, baseColor: .white)
   
   private lazy var oldAnnotation: AnnotationType? = nil
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      bind()
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(mapView, locationBox, userLocationButton)
      mapView.addSubviews(mapPin)
      locationBox.addStackSubviews(titleLabel, addressBox, nextButton)
   }
   
   public override func setLayouts() {
      super.setLayouts()

      let inset: CGFloat = 20.0
      mapView.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
         make.bottom.equalTo(locationBox.snp.top)
      }
      mapPin.snp.makeConstraints { make in
         make.size.equalTo(inset * 2)
         make.center.equalToSuperview()
      }
      userLocationButton.snp.makeConstraints { make in
         make.size.equalTo(40.0)
         make.bottom.equalTo(locationBox.snp.top).offset(inset)
         make.trailing.equalTo(view.safeAreaLayoutGuide).inset(-inset)
      }
      locationBox.snp.makeConstraints { make in
         make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(inset)
         make.height.equalTo(160.0)
      }
   }
   
   public override func setViews() {
      super.setViews()
      mapView.addCameraDelegate(delegate: self)
      navigationItem.setRightBarButton(.init(customView: xButton), animated: true)
   }
   
   private func bind() {
      xButton.rx.tap
         .bind(with: self) { vc, _ in
            vc.dismiss(animated: true)
         }.disposed(by: disposeBag)
      
      userLocationButton.rx.tap
         .bind(with: self) { vc, _ in
            vc.locationManagerDidChangeAuthorization(vc.locationManager)
         }.disposed(by: disposeBag)
      
      nextButton.rx.tap
         .bind(with: self) { vc, _ in
            let pushedVC = WritePostVC()
            let location = vc.mapView.cameraPosition.target
            pushedVC.setLocation(
               .init(latitude: location.lat, longitude: location.lng), vc.addressBox.getAddress()
            )
            vc.pushToVC(WritePostVC())
         }.disposed(by: disposeBag)
      
      self.locationManagerDidChangeAuthorization(locationManager)
   }
}

extension WritePostMapVC: NMFMapViewCameraDelegate {
   public func mapViewCameraIdle(_ mapView: NMFMapView) {
      let location = mapView.cameraPosition.target
      convertToAddress(
         .init(latitude: location.lat, longitude: location.lng)
      ) { [weak self] address in
         self?.addressBox.setAddress(address)
      }
   }
}

extension WritePostMapVC: CLLocationManagerDelegate {
   public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      let status = manager.authorizationStatus
      if status == .denied || status == .notDetermined {
         manager.requestWhenInUseAuthorization()
      }
      if status == .authorizedAlways || status == .authorizedWhenInUse {
         manager.startUpdatingLocation()
         guard let location = manager.location?.coordinate else { return }
         mapView.moveToLocation(.init(lat: location.latitude, lng: location.longitude))
      }
   }
   
   private func convertToAddress(
      _ coordinate: CLLocationCoordinate2D,
      _ addressHandler: @escaping (String) -> Void
   ) {
      let geocoder = CLGeocoder()
      let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
      geocoder.reverseGeocodeLocation(location) { placemark, error in
         guard error == nil else { return }
         guard let placemark = placemark?.first else { return }
         addressHandler("\(placemark.locality ?? "") \(placemark.name ?? "")")
      }
   }
}
