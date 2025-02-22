// hankyeol-dev. Profile

import UIKit
import CommonUI
import Domain
import SnapKit
import RxSwift
import Then

public final class ProfileMyPostListCell: BaseTableViewCell {
   public let disposeBag: DisposeBag = .init()
   private let sectionLabel: BaseLabel = .init(.init(text: "나의 마이슐랭", style: .base, color: .grayLg))
   private let collection: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      let width = (UIScreen.main.bounds.width / 3) - 20.0
      layout.itemSize = CGSize(width: width, height: width)
      layout.scrollDirection = .vertical
      layout.minimumLineSpacing = 10.0

      let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
      view.register(cellType: ProfileMyPostCell.self)
      view.showsVerticalScrollIndicator = false
      view.isScrollEnabled = false
      return view
   }()
   private let bottom: UIView = .init()
   
   public override func setView() {
      super.setView()
      contentView.addSubviews(sectionLabel, collection, bottom)
      sectionLabel.snp.makeConstraints { make in
         make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10.0)
         make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20.0)
         make.height.equalTo(20.0)
      }
      collection.snp.makeConstraints { make in
         make.top.equalTo(sectionLabel.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20.0)
      }
      bottom.snp.makeConstraints { make in
         make.top.equalTo(collection.snp.bottom)
         make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide)
         make.height.equalTo(10.0)
      }
   }
   
   public func setCell(_ datas: [ProfileMyPostCell.CellData]) {
      collection.delegate = nil
      collection.dataSource = nil
      Observable.just(datas)
         .bind(to: collection.rx.items(
            cellIdentifier: ProfileMyPostCell.id,
            cellType: ProfileMyPostCell.self)) { _, item, cell in
               cell.setCell(item)
            }.disposed(by: disposeBag)
   }
}

public final class ProfileMyPostCell: BaseCollectionViewCell {
   private let icon: UIImageView = .init()
   private let countLabel: BaseLabel = .init(.init(style: .largeTitle, color: .grayMd))
   
   public struct CellData: Equatable {
      let category: FoodCategories
      let count: Int
   }
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubviews(icon, countLabel)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      icon.snp.makeConstraints { make in
         make.top.equalTo(contentView.safeAreaLayoutGuide).inset(18.0)
         make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20.0)
         make.size.equalTo(40.0)
      }
      countLabel.snp.makeConstraints { make in
         make.bottom.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20.0)
      }
   }
   
   public override func setView() {
      super.setView()
      contentView.backgroundColor = .grayXs.withAlphaComponent(0.5)
      contentView.clipsToBounds = true
      contentView.layer.cornerRadius = 10.0
   }
   
   public func setCell(_ data: CellData) {
      icon.image = data.category.toIcons
      countLabel.setText(String(data.count))
      if data.count > 0 {
         countLabel.setTextColor(.black)
      } else {
         countLabel.setTextColor(.grayMd)
      }
   }
}
