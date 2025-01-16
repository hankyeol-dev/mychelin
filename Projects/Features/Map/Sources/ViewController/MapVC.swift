//

import UIKit
import MapKit

import Domain
import CommonUI
import SnapKit
import ReactorKit
import RxCoreLocation
import Tabman
import Pageboy

public final class MapVC: BaseVC {
   public var disposeBag: DisposeBag = .init()

   private let displayTypeButton: RoundedButton = .init("", backgroundColor: .black, baseColor: .white)
   private let listTableView: UITableView = .init().then {
      $0.backgroundColor = .grayXs
   }
   private let mapView: MKMapView = .init().then {
      $0.showsUserLocation = true
   }
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      self.reactor = MapReactor()
      navigationController?.navigationBar.isHidden = true
   }
   
   public override func setViews() {
      super.setViews()
      displayTypeButton.titleLabel?.font = .systemFont(ofSize: 10.0)
   }
}

extension MapVC {
   private func setMapView() {
      listTableView.removeFromSuperview()
      displayTypeButton.removeFromSuperview()
      
      view.addSubviews(mapView, displayTypeButton)
      displayTypeButton.setTitle("리스트뷰", for: .normal)
      displayTypeButton.titleLabel?.font = .systemFont(ofSize: 10.0)
      
      mapView.snp.makeConstraints { make in
         make.top.horizontalEdges.equalToSuperview()
         make.bottom.equalTo(view.safeAreaLayoutGuide)
      }
      displayTypeButton.snp.makeConstraints { make in
         make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20.0)
         make.height.equalTo(30.0)
      }
      
      view.layoutIfNeeded()
   }
   
   private func setListView() {
      mapView.removeFromSuperview()
      displayTypeButton.removeFromSuperview()
      
      view.addSubviews(listTableView, displayTypeButton)
      displayTypeButton.setTitle("지도뷰", for: .normal)
      
      listTableView.snp.makeConstraints { make in
         make.edges.equalTo(view.safeAreaLayoutGuide)
      }
      displayTypeButton.snp.makeConstraints { make in
         make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20.0)
         make.height.equalTo(30.0)
      }
      
      view.layoutIfNeeded()
   }
}

extension MapVC: View {
   public func bind(reactor: MapReactor) {
      bindActions(reactor)
      bindStates(reactor)
   }
   
   private func bindActions(_ reactor: MapReactor) {
      reactor.action.onNext(.didLoad)
      displayTypeButton.rx.tap
         .map({ Reactor.Action.tapDisplayTypeButton })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
   }
   
   private func bindStates(_ reactor: MapReactor) {
      reactor.state.map(\.displayType)
         .distinctUntilChanged()
         .bind(with: self) { vc, type in
            switch type {
            case .map: vc.setMapView()
            case .list: vc.setListView()
            }
         }.disposed(by: disposeBag)
      
      reactor.state.compactMap(\.currentLocation)
         .bind(with: self) { vc, location in
            let region: MKCoordinateRegion = .init(center: location,
                                                   latitudinalMeters: 200,
                                                   longitudinalMeters: 200)
            vc.mapView.setRegion(region, animated: true)
         }.disposed(by: disposeBag)
   }
}

extension MapVC: MKMapViewDelegate {
   public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
      
   }
   
   public func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
      guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
      var annotationView: MKAnnotationView?
      if let pin = annotation as? AnnotationType {
         annotationView = setupAnnotation(annotation: pin, mapView)
      }
      return annotationView
   }
   
   public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
      print(view)
   }
   
   private func setupAnnotation(annotation: AnnotationType, _ mapView: MKMapView) -> MKAnnotationView {
      return mapView.dequeueReusableAnnotationView(
         withIdentifier: String(describing: MapAnnotationView.self),
         for: annotation)
   }
   
   private func addAnnotation(_ location: CLLocationCoordinate2D) {
      let annotation = AnnotationType(pinColor: .greenMd, coordinate: location)
//      mapView.removeAnnotations(mapView.annotations)
      mapView.addAnnotation(annotation)
   }
}
