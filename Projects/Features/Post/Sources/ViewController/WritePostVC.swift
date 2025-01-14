// hankyeol-dev. Post

import UIKit
import MapKit

import CommonUI
import RxSwift
import RxCocoa
import ReactorKit
import Then
import SnapKit

public final class WritePostVC: BaseVC {
   public var disposeBag: DisposeBag = .init()
   private var location: CLLocationCoordinate2D?
   private var address: String = ""
   
   private let xButton: UIButton = .init().then {
      $0.setImage(.xmarkOutline, for: .normal)
   }
   private let backButton: UIButton = .init().then {
      let image: UIImage = .leftOutline.withRenderingMode(.alwaysTemplate)
      $0.setImage(image, for: .normal)
      $0.tintColor = .black
   }
   private let scrollView: UIScrollView = .init().then {
      $0.backgroundColor = .grayXs
      $0.showsVerticalScrollIndicator = false
   }
   private let back: UIView = .init()
   private let locationField: RoundedField = .init("장소 위치").then {
      $0.fieldDisabled()
   }
   private let map: MKMapView = .init().then {
      $0.layer.cornerRadius = 10.0
      $0.isScrollEnabled = false
   }
   private let mapPin: UIImageView = .init().then {
      $0.image = .pin.withRenderingMode(.alwaysTemplate)
      $0.tintColor = .errors
   }
   private let locationNameField: RoundedField = .init("장소 이름", placeholder: "장소에 대한 대략적인 이름")
   private let bottomView: UIView = .init().then { $0.backgroundColor = .grayLg }
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      setNavigationItems()
   }
   
   public override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.reactor = WritePostReactor()
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubview(scrollView)
      scrollView.addSubview(back)
      back.addSubviews(map, locationField, locationNameField, bottomView)
      map.addSubview(mapPin)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let inset = 20.0
      let verticalSpace = 10.0
      let guide = back.safeAreaLayoutGuide
      scrollView.snp.makeConstraints { make in
         make.edges.equalTo(view.safeAreaLayoutGuide)
      }
      back.snp.makeConstraints { make in
         make.width.equalTo(scrollView.snp.width)
         make.verticalEdges.equalTo(scrollView)
      }
      map.snp.makeConstraints { make in
         make.top.equalTo(guide).inset(inset)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(150.0)
      }
      mapPin.snp.makeConstraints { make in
         make.center.equalToSuperview()
      }
      locationField.snp.makeConstraints { make in
         make.top.equalTo(map.snp.bottom).offset(inset)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(70.0)
      }
      locationNameField.snp.makeConstraints { make in
         make.top.equalTo(locationField.snp.bottom).offset(verticalSpace)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(70.0)
      }
      bottomView.snp.makeConstraints { make in
         make.top.equalTo(locationNameField.snp.bottom).offset(inset)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.height.equalTo(1000)
         make.bottom.equalTo(guide)
      }
   }
   
   private func setNavigationItems() {
      navigationItem.setRightBarButton(.init(customView: xButton), animated: true)
      navigationItem.setLeftBarButton(.init(customView: backButton), animated: true)
   }
   
   public func setLocation(_ location: CLLocationCoordinate2D, _ address: String) {
      self.location = location
      self.address = address
   }
}

extension WritePostVC: View {
   public func bind(reactor: WritePostReactor) {
      bindActions(reactor)
      bindStates(reactor)
   }
   
   private func bindActions(_ reactor: WritePostReactor) {
      xButton.rx.tap.bind(with: self) { vc, _ in
         vc.dismiss(animated: true)
      }.disposed(by: disposeBag)
      
      backButton.rx.tap.bind(with: self) { vc, _ in
         vc.navigationController?.popViewController(animated: true)
      }.disposed(by: disposeBag)
      
      reactor.action.onNext(.didLoad(location, address))
   }
   
   private func bindStates(_ reactor: WritePostReactor) {
      reactor.state.map(\.location)
         .compactMap({ $0 })
         .bind(with: self) { vc, location in
            print(location)
            let region: MKCoordinateRegion = .init(center: location,
                                                   latitudinalMeters: 50,
                                                   longitudinalMeters: 50)
            vc.map.setRegion(region, animated: false)
         }.disposed(by: disposeBag)
      reactor.state.map(\.address)
         .bind(with: self) { vc, address in
            print(address)
            vc.locationField.setTextField(address)
         }.disposed(by: disposeBag)
   }
}
