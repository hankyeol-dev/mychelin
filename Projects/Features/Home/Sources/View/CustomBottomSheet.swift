// hankyeol-dev. Home

import UIKit
import CommonUI
import Domain
import SnapKit
import Then
import RxSwift
import RxGesture

public final class CustomBottomSheet: PassThroughView {
   private let disposeBag: DisposeBag = .init()
   
   public enum SheetMode {
      case tip, single, full
   }
   private enum SheetConst {
      static let duration: TimeInterval = 0.8
      static let radius: CGFloat = 10.0
      static let height: (SheetMode) -> Double = { mode in
         switch mode {
         case .tip: 80.0
         case .single: 150.0
         case .full: 600.0
         }
      }
   }
   
   private var sheetMode: SheetMode = .tip {
      didSet {
         self.updateBottomsheetLayout(self.sheetMode, offset: SheetConst.height(self.sheetMode))
      }
   }
   private var isEmpty: Bool = false {
      didSet {
         if sheetMode == .full && isEmpty {
            setEmptyView()
         }
         
         if sheetMode == .tip && isEmpty {
            hideEmptyView()
         }
      }
   }
   
   public let innerView: UIView = .init().then {
      $0.backgroundColor = .white
      $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      $0.layer.cornerRadius = SheetConst.radius
      $0.clipsToBounds = true
   }
   public let barView: UIView = .init().then {
      $0.backgroundColor = .graySm
      $0.layer.cornerRadius = 2.0
   }
   private let titleView: BaseLabel = .init(.init(style: .title, color: .black))
   private let postTable: UITableView = .init().then {
      $0.rowHeight = UITableView.automaticDimension
      $0.showsVerticalScrollIndicator = false
      $0.rowHeight = UITableView.automaticDimension
      $0.sectionIndexColor = .clear
      $0.register(cellType: HomePostCell.self)
      $0.separatorColor = .clear
   }

   private let emptyView: UIView = .init().then { $0.backgroundColor = .clear }
   private let emptyLabelTitle: BaseLabel = .init(.init(text: "새로운 마이슐랭을 등록해보세요", style: .title, color: .black))
   private let emptyLabel: BaseLabel = .init(.init(text: "분식, 돈까스, 제육.. 뭐든 좋아요!", style: .base, color: .grayMd))
   public let emptyBtn: RoundedChip = .init(.grayXs.withAlphaComponent(0.5), .black).then {
      $0.setText("+ 마이슐랭 추가")
      $0.setBorder(.black)
   }
   
   public override func setSubviews() {
      super.setSubviews()
      addSubview(innerView)
      innerView.addSubviews(barView, titleView, postTable)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      innerView.snp.makeConstraints { make in
         make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
         make.height.equalTo(SheetConst.height(.tip))
      }
      barView.snp.makeConstraints { make in
         make.centerX.equalTo(innerView.safeAreaLayoutGuide)
         make.top.equalTo(innerView.safeAreaLayoutGuide).inset(15.0)
         make.width.equalTo(50.0)
         make.height.equalTo(5.0)
      }
      titleView.snp.makeConstraints { make in
         make.top.equalTo(barView.snp.bottom).offset(20.0)
         make.centerX.equalTo(innerView.safeAreaLayoutGuide)
      }
   }
   
   public override func setViews() {
      super.setViews()
      
      barView.rx.panGesture()
         .bind(with: self) { v, recognizer in
            if v.sheetMode != .single {
               let translationY = recognizer.translation(in: self).y
               let minY = v.innerView.frame.minY
               let offset = translationY + minY
               
               if SheetConst.height(.tip)...SheetConst.height(.full) ~= offset {
                  v.updateBottomsheetLayout(v.sheetMode, offset: offset)
                  recognizer.setTranslation(.zero, in: v)
               }
               
               UIView.animate(
                  withDuration: 0,
                  delay: 0,
                  options: .curveEaseOut,
                  animations: v.layoutIfNeeded,
                  completion: nil
               )
               
               guard recognizer.state == .ended else { return }
               UIView.animate(
                  withDuration: SheetConst.duration,
                  delay: 0,
                  options: .allowUserInteraction,
                  animations: {
                     v.sheetMode = recognizer.velocity(in: v).y >= 0 ? .tip : .full
                     if v.isEmpty { v.isEmpty = true }
                  },
                  completion: nil
               )
            }
         }.disposed(by: disposeBag)
   }
}

extension CustomBottomSheet {
   private func updateBottomsheetLayout(_ mode: SheetMode, offset: Double) {
      innerView.snp.updateConstraints { make in
         make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
         make.height.equalTo(offset)
      }
      switch sheetMode {
      case .tip:
         addSubview(titleView)
         titleView.snp.makeConstraints { make in
            make.top.equalTo(barView.snp.bottom).offset(20.0)
            make.centerX.equalTo(innerView.safeAreaLayoutGuide)
         }
      case .single:
         titleView.removeFromSuperview()
      case .full:
         titleView.removeFromSuperview()
      }
   }
   
   public func setInnerview(_ data: [GetPostVO]) {
      if data.isEmpty {
         titleView.setText("등록된 마이슐랭이 아직 없어요.")
         isEmpty = true
      } else {
         if sheetMode == .tip {
            titleView.setText("이 지역의 마이슐랭  \(data.count)개")            
         }
      }
   }
   
   private func setEmptyView() {
      postTable.removeFromSuperview()
      
      addSubview(emptyView)
      emptyView.addSubviews(emptyLabelTitle, emptyLabel, emptyBtn)
      emptyView.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }
      emptyLabelTitle.snp.makeConstraints { make in
         make.center.equalToSuperview()
      }
      emptyLabel.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.top.equalTo(emptyLabelTitle.snp.bottom).offset(10.0)
      }
      emptyBtn.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.top.equalTo(emptyLabel.snp.bottom).offset(20.0)
         make.height.equalTo(40.0)
         make.width.equalTo(120.0)
      }
   }
   
   private func hideEmptyView() {
      [emptyView, emptyLabelTitle, emptyBtn, emptyLabel].forEach { $0.removeFromSuperview() }
   }
   
   public func setSinglePost(_ data: GetPostVO) {
      postTable.delegate = nil
      postTable.dataSource = nil
      titleView.setText("")
      addSubview(postTable)
      updateBottomsheetLayout(.single, offset: SheetConst.height(.single))
      postTable.isScrollEnabled = false
      postTable.snp.makeConstraints { make in
         make.top.equalTo(barView.snp.bottom).offset(10.0)
         make.horizontalEdges.bottom.equalToSuperview()
      }
      Observable.just([data])
         .bind(to: postTable.rx.items(
            cellIdentifier: HomePostCell.id,
            cellType: HomePostCell.self)) { _, item, cell in
               cell.setCell(item)
            }.disposed(by: disposeBag)
   }
   
   public func hideSinglePost() {
      postTable.removeFromSuperview()
      sheetMode = .tip
   }
}
