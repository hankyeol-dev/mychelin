// hankyeol-dev. Home

import UIKit
import CommonUI
import SnapKit
import Then

public final class ReloadButton: UIButton {
   private let reloadImage: UIImageView = .init().then {
      $0.image = .init(systemName: "arrow.clockwise")?.withRenderingMode(.alwaysTemplate)
      $0.tintColor = .greenLg
   }
   private let reloadLabel: BaseLabel = .init(.init(style: .caption, color: .greenLg)).then {
      $0.textAlignment = .center
      $0.text = "지금 장소에서 조회"
   }
   
   public override init(frame: CGRect) {
      super.init(frame: frame)
      setViews()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func setViews() {
      backgroundColor = .greenSm
      layer.cornerRadius = 15.0
      addSubviews(reloadImage, reloadLabel)
      reloadImage.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.leading.equalTo(safeAreaLayoutGuide).inset(15.0)
         make.size.equalTo(12.0)
      }
      reloadLabel.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.leading.equalTo(reloadImage.snp.trailing).offset(10.0)
         make.trailing.equalTo(safeAreaLayoutGuide).inset(15.0)
         make.height.equalTo(20.0)
      }
   }
}
