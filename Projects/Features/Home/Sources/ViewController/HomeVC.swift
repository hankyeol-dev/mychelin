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
      mapView.addCameraDelegate(delegate: self)
      mapView.touchDelegate = self
      navigationController?.setNavigationBarHidden(true, animated: true)
      reactor?.action.onNext(.didLoad)
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(mapView, userLocationButton, bottomSheet)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      mapView.snp.makeConstraints { make in
         make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
         make.top.equalToSuperview()
      }
      userLocationButton.snp.makeConstraints { make in
         make.size.equalTo(30.0)
         make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20.0)
         make.bottom.equalTo(view.safeAreaLayoutGuide).inset(120.0)
      }
      bottomSheet.snp.makeConstraints { make in
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
      reloadBtn.rx.tap
         .compactMap({ [weak self] in
            guard let self else { return nil }
            hideReloadBtn()
            return Reactor.Action.switchLocation(lat: mapView.latitude, lng: mapView.longitude, cur: false)
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
         .take(1)
         .bind(with: self) { vc, loc in
            vc.moveToLocation(.init(lat: loc.0, lng: loc.1))
            vc.hideReloadBtn()
         }.disposed(by: disposeBag)
      
      reactor.state.map(\.postList)
         .bind(with: self) { vc, list in
            if !list.data.isEmpty {
               list.data.forEach { post in
                  let marker = NMFMarker(
                     position: .init(lat: post.postLat, lng: post.postLng),
                     iconImage: .init(image: vc.bindMapIcons(post.rate))
                  )
                  let touchHandler = { (overlay: NMFOverlay) -> Bool in
                     reactor.action.onNext(.tapPostMarker(post))
                     return true
                  }
                  marker.touchHandler = touchHandler
                  marker.mapView = vc.mapView
               }
            }
         }.disposed(by: disposeBag)
      
      reactor.state.map(\.tappedPost)
         .skip(2)
         .bind(with: self) { vc, post in
            if let post {
               vc.bottomSheet.setSinglePost(post)
            } else {
               vc.bottomSheet.hideSinglePost()
            }
         }.disposed(by: disposeBag)
   }
   private func bindMapIcons(_ rate: Double) -> UIImage {
      if rate >= 5.0 { return .rate5 }
      if rate >= 4.0 && rate < 5.0 { return .rate4 }
      if rate >= 3.0 && rate < 4.0 { return .rate3 }
      if rate >= 2.0 && rate < 3.0 { return .rate2 }
      return .rate1
   }
}

extension HomeVC: NMFMapViewCameraDelegate, NMFMapViewTouchDelegate {
   private func moveToLocation(_ location: NMGLatLng) {
      let camera = NMFCameraUpdate(scrollTo: location)
      camera.animation = .easeIn
      mapView.moveCamera(camera)
   }
   
   public func mapViewCameraIdle(_ mapView: NMFMapView) {
       displayReloadBtn()
   }
   
   public func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
      hideReloadBtn()
   }
   
   public func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
      self.reactor?.action.onNext(.tapPostMarker(nil))
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
