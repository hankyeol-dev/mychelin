
import UIKit

import CommonUI
import Domain

import SnapKit
import ReactorKit

public final class LoginVC: BaseVC {
   private let emailField: RoundedTextField = .init(placeholder: "이메일을 입력해주세요.",
                                                    keyboardType: .emailAddress,
                                                    selectedTitle: "Email")
   private let passwordField: RoundedTextField = .init(placeholder: "비밀번호를 입력해주세요.",
                                                       keyboardType: .default,
                                                       selectedTitle: "Password",
                                                       isSecure: true)
   private let loginButton: RoundedButton = .init("로그인")
   private let signupButton: UIButton = .init().then {
      $0.setTitle("새로운 계정 만들기", for: .normal)
      $0.setTitleColor(.systemBlue, for: .normal)
      $0.titleLabel?.textAlignment = .center
      $0.titleLabel?.font = .systemFont(ofSize: 11.0, weight: .light)
   }
   
   public override func viewDidLoad() {
      super.viewDidLoad()
      title = "로그인"

      self.reactor = LoginReactor()
      
      signupButton.rx.tap
         .bind(with: self) { vc, _ in
            vc.pushToVC(JoinVC())
         }.disposed(by: disposeBag)
   }
   
   public override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.reactor = nil
   }
   
   public override func setSubviews() {
      super.setSubviews()
      view.addSubviews(emailField, passwordField, loginButton, signupButton)
   }
   
   public override func setLayouts() {
      super.setLayouts()
      emailField.snp.makeConstraints { make in
         make.top.equalTo(view.safeAreaLayoutGuide).inset(5.0)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
         make.height.equalTo(50.0)
      }
      passwordField.snp.makeConstraints { make in
         make.top.equalTo(emailField.snp.bottom).offset(10.0)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
         make.height.equalTo(50.0)
      }
      loginButton.snp.makeConstraints { make in
         make.top.equalTo(passwordField.snp.bottom).offset(15.0)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
         make.height.equalTo(40.0)
      }
      signupButton.snp.makeConstraints { make in
         make.top.equalTo(loginButton.snp.bottom).offset(20.0)
         make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
      }
   }
   
}

extension LoginVC: View {
   public func bind(reactor: LoginReactor) {
      bindActions(reactor: reactor)
      bindStates(reactor: reactor)
   }
   
   private func bindActions(reactor: LoginReactor) {
      emailField.textField.rx
         .text
         .orEmpty
         .distinctUntilChanged()
         .map({ .textEmail($0) })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
      
      passwordField.textField.rx
         .text
         .orEmpty
         .distinctUntilChanged()
         .map({ .textPassword($0) })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
      
      loginButton.rx
         .tap
         .map({ .tapLoginButton })
         .bind(to: reactor.action)
         .disposed(by: disposeBag)
   }
   
   private func bindStates(reactor: LoginReactor) {
      reactor.state.map({ $0.isLoading })
         .distinctUntilChanged()
         .bind(with: self) { vc, isLoading in
            print("vc - isLoading: \(isLoading)")
         }.disposed(by: disposeBag)
      
      reactor.state.map({ $0.isLogined })
         .distinctUntilChanged()
         .bind(with: self) { vc, isLogined in
            print("vc: \(isLogined)")
         }.disposed(by: disposeBag)
   }
}
