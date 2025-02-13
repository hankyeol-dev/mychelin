// hankyeol-dev. Post

import Foundation
import Domain
import CommonUI
import RxDataSources

public struct PostDetailSection {
   public typealias Model = SectionModel<Self.Sections, Self.Items>
   
   public enum Sections: Equatable {
      case post
      case divider
      case comment
   }
   
   public enum Items: Equatable {
      case post(GetPostVO)
      case divider
      case comment(CommentOutputVO)
   }
}
