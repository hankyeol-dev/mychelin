// hankyeol-dev. CommonUI

import UIKit
import Then
import RxSwift
import RxCocoa

public final class SearchField: BaseView {
   private let disposeBag: DisposeBag = .init()
   private let searchIcon: UIImageView = .init().then {
      $0.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
      $0.tintColor = .grayLg
   }
   public let textField: UITextField = .init().then {
      $0.placeholder = "장소명"
      $0.font = .systemFont(ofSize: 14.0)
      $0.tintColor = .grayLg
      $0.textColor = .grayLg
      $0.backgroundColor = .clear
   }
   public let deleteButton: UIButton = .init().then {
      $0.layer.cornerRadius = 10.0
      $0.setImage(.init(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate),
                  for: .normal)
      $0.tintColor = .grayLg
   }
   
   public override func setSubviews() {
      super.setSubviews()
      addSubviews(searchIcon, textField, deleteButton)
   }
   
   public override func setView() {
      super.setView()
      backgroundColor = .grayXs
      layer.cornerRadius = 10.0
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let inset = 20.0
      searchIcon.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.leading.equalTo(safeAreaLayoutGuide).inset(inset)
         make.size.equalTo(15.0)
      }
      textField.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.leading.equalTo(searchIcon.snp.trailing).offset(10.0)
         make.trailing.equalTo(safeAreaLayoutGuide).inset(45.0)
      }
      deleteButton.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.trailing.equalTo(safeAreaLayoutGuide).inset(20.0)
         make.size.equalTo(15.0)
      }
   }
}

