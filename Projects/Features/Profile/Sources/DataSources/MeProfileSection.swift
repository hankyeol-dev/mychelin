// hankyeol-dev. Profile

import UIKit

import Domain
import CommonUI

import RxDataSources

public struct MeProfileSection {
   public typealias Model = SectionModel<Self.Sections, Self.Items>
   
   public enum Sections: Equatable {
      case info
      case divider
      case edit
      case post
      case logout
   }
   
   public enum Items: Equatable {
      case info(MeProfileVO)
      case divider
      case edit(MeProfileMenuItem)
      case post(MeProfileMenuItem)
      case logout(MeProfileMenuItem)
   }
}

public struct MeProfileMenuItem: Equatable {
   public let icon: UIImage
   public let label: String
}

