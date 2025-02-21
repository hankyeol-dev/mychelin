// hankyeol-dev. Post

import UIKit
import CommonUI
import Domain
import SnapKit
import Then
import RxSwift

public final class PostImageCell: BaseCollectionViewCell {
   public let disposeBag: DisposeBag = .init()
   
   private let imageView: UIImageView = .init().then {
      $0.layer.cornerRadius = 8
      $0.clipsToBounds = true
      $0.contentMode = .scaleAspectFill
   }
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubview(imageView)
      imageView.snp.makeConstraints { make in
         make.edges.equalTo(contentView.safeAreaLayoutGuide)
      }
   }
   
   public func setCell(_ url: String) {
      imageView.setImage(url)
   }
}
