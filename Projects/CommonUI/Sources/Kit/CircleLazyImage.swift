// hankyeol-dev. CommonUI

import UIKit

import Domain

import SnapKit
import Kingfisher
import Then

public final class CircleLazyImage: BaseView {
   private let imageView: UIImageView = .init()
   
   public convenience init(round: CGFloat) {
      self.init()
      setRounds(round)
   }
   
   override func setSubviews() {
      super.setSubviews()
      addSubview(imageView)
   }
   
   override func setLayouts() {
      super.setLayouts()
      imageView.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }
   }
}

extension CircleLazyImage {
   public func setImage(_ urlString: String) {
      imageView.setImage(urlString)
   }
   
   private func setRounds(_ round: CGFloat) {
      layer.cornerRadius = round
      layer.masksToBounds = true
      imageView.contentMode = .scaleAspectFill
   }
}
