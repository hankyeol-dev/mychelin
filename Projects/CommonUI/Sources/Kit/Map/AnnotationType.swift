// hankyeol-dev. CommonUI

import Foundation
import MapKit

final public class AnnotationType: NSObject, MKAnnotation {
   @objc public dynamic var coordinate: CLLocationCoordinate2D
   public var pinColor: UIColor
   
   public init(pinColor: UIColor, coordinate: CLLocationCoordinate2D) {
      self.pinColor = pinColor
      self.coordinate = coordinate
   }
}
