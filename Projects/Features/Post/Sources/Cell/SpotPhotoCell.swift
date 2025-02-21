// hankyeol-dev. Post

import UIKit
import CommonUI
import Then
import SnapKit
import RxSwift

public final class SpotPhotoCell: BaseCollectionViewCell {
   public var disposeBag: DisposeBag = .init()
   
   private let imageView: UIImageView = .init().then {
      $0.contentMode = .scaleAspectFill
   }
   public let closeButton: UIButton = .init().then {
      $0.backgroundColor = .errors
      $0.setImage(.xmarkOutline.withRenderingMode(.alwaysTemplate), for: .normal)
      $0.tintColor = .white
      $0.layer.cornerRadius = 10.0
   }
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubviews(imageView, closeButton)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      imageView.snp.makeConstraints { make in
         make.top.trailing.equalTo(safeAreaLayoutGuide).inset(10.0)
         make.leading.bottom.equalTo(contentView.safeAreaLayoutGuide)
      }
      closeButton.snp.makeConstraints { make in
         make.top.trailing.equalTo(contentView.safeAreaLayoutGuide)
         make.size.equalTo(20.0)
      }
   }
   
   public override func setView() {
      super.setView()
      contentView.clipsToBounds = true
   }
   
   public override func prepareForReuse() {
      super.prepareForReuse()
      disposeBag = .init()
   }
   
   public func setCell(_ provider: NSItemProvider) {
      if provider.canLoadObject(ofClass: UIImage.self) {
         provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            
            guard let self = self,
                  let image = image as? UIImage else { return }
            
            DispatchQueue.main.async { [weak self] in
               self?.imageView.image = image
            }
         }
      }
   }
}
