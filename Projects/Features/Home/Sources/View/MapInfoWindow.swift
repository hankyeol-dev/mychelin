// hankyeol-dev. Home

import UIKit
import NMapsMap

public final class MapInfoWindow: NMFInfoWindow {
   public struct InfoConst {
      let infoString: String
   }
   
   private var infoConst: InfoConst
   
   public init(infoConst: InfoConst) {
      self.infoConst = infoConst
      
      let dataSource = NMFInfoWindowDefaultTextSource.data()
      dataSource.title = infoConst.infoString
      
      super.init()
      self.dataSource = dataSource
   }
}
