// hankyeol-dev. Post

import UIKit
import CommonUI
import SnapKit
import RxSwift

public final class FoodCategoryVC: BaseVC {
   private let disposeBag: DisposeBag = .init()

   private var selectedCategory: FoodCategories?
   public var dismissHandler: ((FoodCategories) -> Void)?
   
   private let vcTitle: BaseLabel = .init(.init(text: "카테고리 선택", style: .largeTitle))
   private lazy var categoryCollection: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      let width = UIScreen.main.bounds.width
      let height = 100.0
      layout.itemSize = .init(width: ((width - 70.0) / 3.0), height: height)
      layout.minimumLineSpacing = 15.0
      
      let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
      view.register(cellType: FoodCategoryCell.self)
      view.showsVerticalScrollIndicator = false
      return view
   }()
   
   public override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   public override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      if let selectedCategory {
         dismissHandler?(selectedCategory)
      }
   }
   
   public func bind(_ category: FoodCategories) {
      view.addSubviews(vcTitle, categoryCollection)
      vcTitle.snp.makeConstraints { make in
         make.top.equalTo(view.safeAreaLayoutGuide).inset(30.0)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20.0)
      }
      categoryCollection.snp.makeConstraints { make in
         make.top.equalTo(vcTitle.snp.bottom).offset(20.0)
         make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20.0)
      }
      
      Observable.just(FoodCategories.toShuffled(category))
         .bind(to: categoryCollection.rx.items(
            cellIdentifier: FoodCategoryCell.id,
            cellType: FoodCategoryCell.self)) { _, item, cell in
               cell.bindCell(item, isSelected: item == category)
            }.disposed(by: disposeBag)
      
      categoryCollection.rx.modelSelected(FoodCategories.self)
         .bind(with: self) { vc, category in
            vc.selectedCategory = category
            vc.dismiss(animated: true)
         }.disposed(by: disposeBag)
   }
}
