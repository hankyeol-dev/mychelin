// hankyeol-dev. Post

import UIKit
import MapKit
import CommonUI

import RxCocoa
import ReactorKit
import RxMKMapView
import SnapKit
import Then

public final class WritePostMapVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   private let xButton: UIButton = .init().then {
      $0.setImage(.xmarkOutline, for: .normal)
      $0.tintColor = .grayLg
   }
   private let mapView: MKMapView = .init().then {
      $0.register(MapAnnotationView.self,
                  forAnnotationViewWithReuseIdentifier: String(describing: MapAnnotationView.self))
      $0.showsUserLocation = true
   }
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
   private let titleLabel: BaseLabel = .init(.init(style: .title))
   private let addressBox: AddressBox = .init().then { $0.setBackground(.grayXs) }
   private let nextButton: RoundedButton = .init("위치 설정", backgroundColor: .greenMd, baseColor: .white)
   
   private lazy var oldAnnotation: AnnotationType? = nil
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      setDismissButton()
   }
   
   public override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.reactor = WritePostMapReactor()
   }
   
   public override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.reactor = nil
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(mapView, locationBox)
      mapView.addSubview(mapPin)
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
      locationBox.snp.makeConstraints { make in
         make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(inset)
         make.height.equalTo(160.0)
      }
   }
   
   public override func setViews() {
      super.setViews()
      mapView.delegate = self
      titleLabel.setText("글에 등록할 주소를 입력해주세요.")
   }
   
   private func setDismissButton() {
      navigationItem.setRightBarButton(.init(customView: xButton), animated: true)
   }
}

extension WritePostMapVC: MKMapViewDelegate {
   private func setMapLocation(_ location: CLLocationCoordinate2D) {
      let region: MKCoordinateRegion = .init(center: location,
                                             latitudinalMeters: 100,
                                             longitudinalMeters: 100)
      mapView.setRegion(region, animated: true)
   }
   
   private func addAnnotation(_ location: CLLocationCoordinate2D) {
      let annotation = AnnotationType(pinColor: .greenMd, coordinate: location)
      oldAnnotation = annotation
      mapView.addAnnotation(annotation)
   }
   
   private func setupAnnotation(annotation: AnnotationType, _ mapView: MKMapView) -> MKAnnotationView {
      return mapView.dequeueReusableAnnotationView(
         withIdentifier: String(describing: MapAnnotationView.self),
         for: annotation)
   }
   
   public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
      reactor?.action.onNext(.moveLocation(mapView.centerCoordinate))
   }
   
   public func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
      guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
      var annotationView: MKAnnotationView?
      if let pin = annotation as? AnnotationType {
         annotationView = setupAnnotation(annotation: pin, mapView)
      }
      return annotationView
   }
}

extension WritePostMapVC: View {
   public func bind(reactor: WritePostMapReactor) {
      bindActions(reactor)
      bindStates(reactor)
   }
   
   private func bindActions(_ reactor: WritePostMapReactor) {
      reactor.action.onNext(.didLoad)
      
      xButton.rx.tap
         .bind(with: self) { vc, _ in
            vc.dismiss(animated: true)
         }.disposed(by: disposeBag)
      
      nextButton.rx.tap
         .map({ Reactor.Action.tapNextButton })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
   }
   
   private func bindStates(_ reactor: WritePostMapReactor) {
      reactor.state.compactMap(\.currentLocation)
         .bind(with: self) { vc, location in
            vc.setMapLocation(location)
         }.disposed(by: disposeBag)
      
      reactor.state.compactMap(\.currentAddress)
         .filter({ !$0.isEmpty })
         .bind(with: self) { vc, address in
            vc.addressBox.setAddress(address)
         }.disposed(by: disposeBag)
      
      reactor.state.map(\.isTapNextButton)
         .bind(with: self) { vc, isTapped in
            if isTapped {
               vc.pushToVC(WritePostVC())
            }
         }.disposed(by: disposeBag)
   }
}
