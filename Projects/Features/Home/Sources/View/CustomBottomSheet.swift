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
      case tip, full
   }
   private enum SheetConst {
      static let duration: TimeInterval = 0.8
      static let radius: CGFloat = 10.0
      static let ratio: (SheetMode) -> Double = { mode in
         switch mode {
         case .tip: 0.9 * UIScreen.main.bounds.height
         case .full: 0.2 * UIScreen.main.bounds.height
         }
      }
   }
   
   private var sheetMode: SheetMode = .tip {
      didSet {
         self.updateBottomsheetLayout(self.sheetMode, offset: SheetConst.ratio(self.sheetMode))
      }
   }
   
   public let innerView: UIView = .init().then {
      $0.backgroundColor = .grayXs
      $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      $0.layer.cornerRadius = SheetConst.radius
      $0.clipsToBounds = true
   }
   public let barView: UIView = .init().then {
      $0.backgroundColor = .graySm
      $0.layer.cornerRadius = 2.0
   }
   private let titleView: BaseLabel = .init(.init(style: .largeTitle, color: .black))
   private let postTable: UITableView = .init().then {
      $0.rowHeight = UITableView.automaticDimension
      $0.showsVerticalScrollIndicator = false
   }
   
   public override func setSubviews() {
      super.setSubviews()
      addSubview(innerView)
      innerView.addSubviews(barView, titleView)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      innerView.snp.makeConstraints { make in
         make.left.right.bottom.equalToSuperview()
         make.top.equalToSuperview().inset(SheetConst.ratio(.tip))
      }
      barView.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.top.equalToSuperview().inset(15.0)
         make.width.equalTo(60.0)
         make.height.equalTo(5.0)
      }
      titleView.snp.makeConstraints { make in
         make.top.equalTo(barView.snp.bottom).offset(20.0)
         make.centerX.equalToSuperview()
      }
   }
   
   public override func setViews() {
      super.setViews()
      self.rx.panGesture()
         .bind(with: self) { v, recognizer in
            let translationY = recognizer.translation(in: self).y
            let minY = v.innerView.frame.minY
            let offset = translationY + minY
            
            if SheetConst.ratio(.full)...SheetConst.ratio(.tip) ~= offset {
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
                  v.sheetMode = recognizer.velocity(in: self).y >= 0 ? .tip : .full
               },
               completion: nil
            )
            
         }.disposed(by: disposeBag)
   }
}

extension CustomBottomSheet {
   private func updateBottomsheetLayout(_ mode: SheetMode, offset: Double) {
      innerView.snp.updateConstraints { make in
         make.left.right.bottom.equalToSuperview()
         make.top.equalToSuperview().offset(offset)
      }
      switch sheetMode {
      case .tip:
         titleView.snp.makeConstraints { make in
            make.top.equalTo(barView.snp.bottom).offset(20.0)
            make.centerX.equalToSuperview()
         }
         titleView.textAlignment = .center
         titleView.updateStyle(.init(style: .largeTitle, color: .black))
      case .full:
         titleView.snp.makeConstraints { make in
            make.top.equalTo(barView.snp.bottom).offset(20.0)
            make.leading.equalToSuperview().inset(20.0)
         }
         titleView.textAlignment = .left
         titleView.updateStyle(.init(style: .title, color: .grayLg.withAlphaComponent(1.5)))
      }
   }
   
   public func setInnerview(_ data: [GetPostVO]) {
      titleView.setText("이 지역의 마이슐랭  \(data.count)개")
      if data.isEmpty {
         
      } else {
         
      }
   }
}
