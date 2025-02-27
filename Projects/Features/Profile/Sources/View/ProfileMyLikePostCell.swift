// hankyeol-dev. Profile

import UIKit
import Domain
import CommonUI
import SnapKit
import RxSwift
import Then

public final class ProfileMyLikePostListCell: BaseTableViewCell {
   private let disposeBag: DisposeBag = .init()
   private let labelSection: UIView = .init().then {
      $0.backgroundColor = .white
   }
   private let label: BaseLabel = .init(
      .init(text: "찜한 마이슐랭 리스트 💚", style: .largeTitle, color: .black.withAlphaComponent(0.8))
   )
   private let arrow: UIImageView = .init(image: .init(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)).then {
      $0.tintColor = .black.withAlphaComponent(0.8)
   }
   private lazy var likePosts: UICollectionView = .init(frame: .zero, collectionViewLayout: createCollectionLayout()).then {
      $0.showsHorizontalScrollIndicator = false
      $0.register(cellType: ProfileMyLikePostCell.self)
   }
   
   public override func setSubviews() {
      super.setSubviews()
      contentView.addSubviews(labelSection, likePosts)
      labelSection.addSubviews(label, arrow)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      let guide = contentView.safeAreaLayoutGuide
      let inset = 20.0
      labelSection.snp.makeConstraints { make in
         make.top.equalTo(guide).inset(40.0)
         make.horizontalEdges.equalTo(guide).inset(inset)
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
      likePosts.snp.makeConstraints { make in
         make.top.equalTo(labelSection.snp.bottom).offset(15.0)
         make.leading.equalTo(guide).inset(inset)
         make.trailing.equalTo(guide)
         make.height.equalTo(250.0)
         make.bottom.equalTo(guide).inset(inset)
      }
   }
   
   public func setCell(_ datas: [GetPostVO]) {
      likePosts.delegate = nil
      likePosts.dataSource = nil
      Observable.just(datas)
         .bind(to: likePosts.rx.items(cellIdentifier: ProfileMyLikePostCell.id,
                                      cellType: ProfileMyLikePostCell.self)) { _, item, cell in
            cell.setCell(item)
         }.disposed(by: disposeBag)
   }
   
   private func createCollectionLayout() -> UICollectionViewCompositionalLayout {
      let itemSize = NSCollectionLayoutSize(
         widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10.0)
      
      let groupSize = NSCollectionLayoutSize(
         widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(1.0))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      section.contentInsets = .init(top: 10.0, leading: 0.0, bottom: 10.0, trailing: 0.0)
      
      return UICollectionViewCompositionalLayout(section: section)
   }
}

private final class ProfileMyLikePostCell: BaseCollectionViewCell {
   private let image: UIImageView = .init().then {
      $0.contentMode = .scaleAspectFill
   }
   private let sectionChip: UIView = .init().then {
      $0.backgroundColor = .greenSm
      $0.layer.cornerRadius = 5.0
   }
   private let chipLabel: BaseLabel = .init(.init(style: .subtitle, color: .greenLg))
   private let content: UIView = .init().then {
      $0.backgroundColor = .grayXs
      $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
      $0.layer.cornerRadius = 5.0
   }
   private let titleLabel: BaseLabel = .init(.init(style: .title, color: .black))
   private let addressLabel: BaseLabel = .init(.init(style: .base, color: .grayLg))
   private let rateChip: UIView = .init().then {
      $0.backgroundColor = .systemYellow
      $0.layer.cornerRadius = 5.0
   }
   private let rateLabel: BaseLabel = .init(.init(style: .subtitle, color: .white))
   private let rateStar: UIImageView = .init(image: .starFill.withRenderingMode(.alwaysTemplate)).then {
      $0.tintColor = .white
   }
   
   override func setSubviews() {
      super.setSubviews()
      contentView.addSubviews(image, sectionChip, content)
      sectionChip.addSubview(chipLabel)
      content.addSubviews(titleLabel, addressLabel, rateChip)
      rateChip.addSubviews(rateStar, rateLabel)
   }
   
   override func setLayouts() {
      super.setLayouts()
      let guide = contentView.safeAreaLayoutGuide
      let contentGuide = content.safeAreaLayoutGuide
      sectionChip.snp.makeConstraints { make in
         make.top.leading.equalTo(guide).inset(10.0)
         make.height.equalTo(30.0)
      }
      chipLabel.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.horizontalEdges.equalTo(sectionChip.safeAreaLayoutGuide).inset(10.0)
      }
      image.snp.makeConstraints { make in
         make.top.horizontalEdges.equalTo(guide)
         make.height.equalTo(120.0)
      }
      content.snp.makeConstraints { make in
         make.bottom.horizontalEdges.equalTo(guide)
         make.top.equalTo(image.snp.bottom).inset(10.0)
      }
      titleLabel.snp.makeConstraints { make in
         make.top.leading.equalTo(contentGuide).inset(10.0)
      }
      addressLabel.snp.makeConstraints { make in
         make.top.equalTo(titleLabel.snp.bottom).offset(5.0)
         make.leading.equalTo(contentGuide).inset(10.0)
      }
      rateChip.snp.makeConstraints { make in
         make.top.equalTo(addressLabel.snp.bottom).offset(25.0)
         make.trailing.bottom.equalTo(contentGuide).inset(10.0)
         make.height.equalTo(30.0)
      }
      rateStar.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.leading.equalTo(rateChip.safeAreaLayoutGuide).inset(5.0)
         make.size.equalTo(13.0)
      }
      rateLabel.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.leading.equalTo(rateStar.snp.trailing).offset(10.0)
         make.trailing.equalTo(rateChip.safeAreaLayoutGuide).inset(5.0)
      }
   }
   
   override func setView() {
      contentView.layer.cornerRadius = 5.0
      contentView.clipsToBounds = true
   }
   
   public func setCell(_ data: GetPostVO) {
      if let first = data.files?.first {
         image.setImage(first)
      }
      chipLabel.setText(FoodCategories(rawValue: data.category)?.toCategory ?? FoodCategories.etc.toCategory)
      titleLabel.setText(data.title)
      addressLabel.setText(data.address)
      rateLabel.setText(String(data.rate))
   }
}
