// hankyeol-dev. Post

import UIKit
import CommonUI
import Common
import Domain
import SnapKit
import RxSwift
import Then

public final class PostCommentCell: BaseTableViewCell {
   public let nickLabel: BaseLabel = .init(.init(style: .subtitle))
   private let createdAtLabel: BaseLabel = .init(.init(style: .caption, color: .grayMd))
   private let commentLabel: BaseLabel = .init(.init(style: .caption)).then {
      $0.numberOfLines = 0
   }
   
   convenience init() {
      self.init()
      nickLabel.setTextColor(CurationColors.randomColor)
   }
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubviews(nickLabel, commentLabel, createdAtLabel)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let guide = contentView.safeAreaLayoutGuide
      let inset = 20.0
      nickLabel.snp.makeConstraints { make in
         make.top.equalTo(guide).inset(10.0)
         make.leading.equalTo(guide).inset(inset)
         make.height.equalTo(inset)
      }
      createdAtLabel.snp.makeConstraints { make in
         make.centerY.equalTo(nickLabel.snp.centerY)
         make.trailing.equalTo(guide).inset(inset)
         make.height.equalTo(inset)
      }
      commentLabel.snp.makeConstraints { make in
         make.top.equalTo(nickLabel.snp.bottom).offset(8.0)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.bottom.equalTo(guide).inset(10.0)
      }
   }
   
   public func setCell(_ vo: CommentOutputVO) {
      nickLabel.setText(vo.commentNick)
      createdAtLabel.setText(vo.createdAt)
      commentLabel.setText(vo.content)
   }
}
