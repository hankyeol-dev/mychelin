// hankyeol-dev. Profile

import UIKit
import CommonUI
import Domain
import SnapKit
import RxSwift
import Then

public final class ProfileMyPostListCell: BaseTableViewCell {
   public let disposeBag: DisposeBag = .init()
   private let width = (UIScreen.main.bounds.width - 60.0) / 3
   
   private let labelSection: UIView = .init().then {
      $0.backgroundColor = .white
   }
   private let label: BaseLabel = .init(.init(text: "마이슐랭 리스트 👀", style: .largeTitle, color: .black.withAlphaComponent(0.8)))
   private lazy var postCollection: UICollectionView = {
      let flow = UICollectionViewFlowLayout()
      flow.itemSize = .init(width: width, height: width)
      flow.minimumLineSpacing = 10.0
      let view = UICollectionView(frame: .zero, collectionViewLayout: flow)
      view.register(cellType: ProfileMyPostCell.self)
      view.showsVerticalScrollIndicator = false
      return view
   }()
   private let arrow: UIImageView = .init(image: .init(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)).then {
      $0.tintColor = .black.withAlphaComponent(0.8)
   }
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubviews(labelSection, postCollection)
      labelSection.addSubviews(label, arrow)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let guide = contentView.safeAreaLayoutGuide
      let inset = 20.0
      labelSection.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(guide).inset(inset)
      }
      label.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.leading.equalTo(labelSection.safeAreaLayoutGuide).inset(5.0)
      }
      arrow.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.height.equalTo(18.0)
         make.width.equalTo(10.0)
         make.trailing.equalTo(labelSection.safeAreaLayoutGuide).inset(5.0)
      }
      postCollection.snp.makeConstraints { make in
         make.top.equalTo(label.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(guide).inset(inset)
         make.bottom.equalTo(contentView.safeAreaLayoutGuide)
      }
   }
   
   public func setCell(_ datas: [ProfileMyPostCell.CellData]) {
      postCollection.delegate = nil
      postCollection.dataSource = nil
      
      let ratio = CGFloat((datas.count / 3) + 1)
      let height = (width * ratio) + (10.0 * (ratio - 1)) + 60.0
      
      postCollection.snp.remakeConstraints { make in
         make.top.equalTo(label.snp.bottom).offset(20.0)
         make.height.equalTo(height)
         make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20.0)
         make.bottom.equalTo(contentView.safeAreaLayoutGuide)
      }
      
      Observable.just(datas)
         .bind(to: postCollection.rx.items(cellIdentifier: ProfileMyPostCell.id,
                                           cellType: ProfileMyPostCell.self)) { _ ,item, cell in
            cell.setCell(item)
         }.disposed(by: disposeBag)
   }
   
   public override func setView() {
      super.setView()
      selectionStyle = .none
   }
}

public final class ProfileMyPostCell: BaseCollectionViewCell {
   public let sectionChip: UIView = .init().then {
      $0.backgroundColor = .greenSm.withAlphaComponent(0.5)
      $0.layer.cornerRadius = 5.0
   }
   private let chipLabel: BaseLabel = .init(.init(style: .subtitle, color: .greenLg))
   private let countLabel: BaseLabel = .init(.init(style: .xLargeTitle, color: .grayMd))
   
   public struct CellData: Equatable {
      let category: FoodCategories
      let count: Int
   }
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubviews(sectionChip, countLabel)
      sectionChip.addSubview(chipLabel)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      sectionChip.snp.makeConstraints { make in
         make.top.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10.0)
         make.height.equalTo(30.0)
      }
      chipLabel.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.horizontalEdges.equalTo(sectionChip.safeAreaLayoutGuide).inset(10.0)
      }
      countLabel.snp.makeConstraints { make in
         make.bottom.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20.0)
      }
   }
   
   public override func setView() {
      super.setView()
      contentView.backgroundColor = .grayXs
      contentView.clipsToBounds = true
      contentView.layer.cornerRadius = 10.0
   }
   
   public func setCell(_ data: CellData) {
      chipLabel.setText(data.category.toCategory)
      countLabel.setText(String(data.count))
      if data.count > 0 {
         countLabel.setTextColor(.black)
      } else {
         countLabel.setTextColor(.grayMd)
      }
   }
}
