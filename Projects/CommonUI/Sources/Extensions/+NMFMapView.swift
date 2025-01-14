// hankyeol-dev. CommonUI

import UIKit
import NMapsMap

public extension NMFMapView {
   func moveToLocation(_ location: NMGLatLng) {
      let camera = NMFCameraUpdate(scrollTo: location)
      camera.animation = .easeIn
      self.moveCamera(camera)
   }
}
