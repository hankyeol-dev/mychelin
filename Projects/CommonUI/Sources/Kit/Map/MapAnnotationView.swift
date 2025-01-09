// hankyeol-dev. CommonUI

import UIKit
import MapKit
import Then
import SnapKit

public final class MapAnnotationView: MKAnnotationView {
   private let pinView: UIImageView = .init().then {
      $0.image = .pin.withRenderingMode(.alwaysTemplate)
   }
   
   public override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
      super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
      addSubview(pinView)
      pinView.snp.makeConstraints { make in
         make.size.equalTo(50.0)
      }
   }
   
   public override func prepareForReuse() {
      super.prepareForReuse()
      pinView.image = nil
   }
   
   public override func prepareForDisplay() {
      super.prepareForDisplay()
      guard let annotation = annotation as? AnnotationType else { return }
      
      pinView.tintColor = annotation.pinColor
      
      setNeedsLayout()
   }
   
   public override func layoutSubviews() {
      super.layoutSubviews()
      bounds.size = CGSize(width: 50.0, height: 50.0)
      centerOffset = CGPoint(x: 0.0, y: -25.0)
   }
   
   @available(*, unavailable)
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
