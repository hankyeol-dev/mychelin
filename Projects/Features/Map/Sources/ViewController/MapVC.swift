//

import UIKit
import MapKit

import Domain
import CommonUI
import SnapKit
import ReactorKit
import RxCoreLocation


public final class MapVC: BaseVC {
   private let disposeBag: DisposeBag = .init()
   private let locationService: LocationService = .shared

   private let mapView: MKMapView = .init().then {
      $0.isZoomEnabled = true
      $0.register(MapAnnotationView.self,
                  forAnnotationViewWithReuseIdentifier: String(describing: MapAnnotationView.self))
   }
   private let addressBox: AddressBox = .init()
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      mapView.delegate = self
      navigationController?.navigationBar.isHidden = true
      
      locationService.startUpdateLocation { [weak self] in
         guard let self else { return }
         mapView.showsUserLocation = true
      }
      
      locationService.locationSubject
         .bind(with: self) { vc, location in
            let span: MKCoordinateSpan = .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region: MKCoordinateRegion = .init(center: location, span: span)
            vc.mapView.setRegion(region, animated: true)
         }.disposed(by: disposeBag)
      
      locationService.locationAddress
         .distinctUntilChanged()
         .bind(with: self) { vc, address in
            vc.addressBox.setAddress(address)
         }.disposed(by: disposeBag)
   }
   
   public override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(mapView)
      mapView.addSubviews(addressBox)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      mapView.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }
      addressBox.snp.makeConstraints { make in
         make.top.equalTo(view.safeAreaLayoutGuide).inset(20.0)
         make.horizontalEdges.equalTo(mapView.safeAreaLayoutGuide).inset(20.0)
      }
   }
}

extension MapVC: MKMapViewDelegate {
   public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
      let location: CLLocationCoordinate2D = .init(
         latitude: mapView.centerCoordinate.latitude,
         longitude: mapView.centerCoordinate.longitude)
      locationService.updateLocation(location)
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
