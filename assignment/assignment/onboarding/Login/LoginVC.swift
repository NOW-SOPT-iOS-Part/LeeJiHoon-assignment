//
//  ViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/8/24.
//
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var nickname: String?
    
    private var viewModel: LoginViewModelType = LoginViewModel()
    private let disposeBag = DisposeBag()
    private var loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
        bindViewModel()
    }

    private func setupLoginView() {
        view.addSubview(loginView)
        loginView.frame = view.bounds
        loginView.idTextFieldView.delegate = self
        loginView.passwordTextFieldView.delegate = self

        loginView.idTextFieldView.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        loginView.passwordTextFieldView.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        loginView.xCircleButton.addTarget(self, action: #selector(handleXCircleButtonTap), for: .touchUpInside)
        loginView.makeAccount.addTarget(self, action: #selector(presentModalView), for: .touchUpInside)
    }

    // MARK: - Binding
    private func bindViewModel() {
        // Binding text fields to the view model
        loginView.idTextFieldView.rx.text.orEmpty
            .bind(to: viewModel.idInput)
            .disposed(by: disposeBag)

        loginView.passwordTextFieldView.rx.text.orEmpty
            .bind(to: viewModel.passwordInput)
            .disposed(by: disposeBag)

        // Binding the login button's enabled state to the view model
        viewModel.isLoginButtonEnabled
            .bind(to: loginView.loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        // Handling the login button tap
        loginView.loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.login()
            })
            .disposed(by: disposeBag)

        // Subscribing to the login success
        viewModel.loginSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.navigateToWelcomeScreen()
                } else {
                    self?.showError("로그인에 실패하였습니다.")
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Event Handling
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.checkValid(id: loginView.idTextFieldView.text, password: loginView.passwordTextFieldView.text)
    }

    @objc func handleXCircleButtonTap() {
        loginView.idTextFieldView.text = ""
        loginView.passwordTextFieldView.text = ""
    }

    @objc func presentModalView() {
        let modalViewController = NicknameViewController()
        if let nicknameVC = modalViewController.presentationController as? UISheetPresentationController {
            nicknameVC.detents = [.medium()]
            nicknameVC.prefersGrabberVisible = true
        }
        modalViewController.onSaveNickname = { [weak self] nickname in
            self?.nickname = nickname
            print("닉네임 저장됨: \(nickname)")
        }
        present(modalViewController, animated: true, completion: nil)
    }

    // Navigation
    func navigateToWelcomeScreen() {
        let welcomeVC = WelcomeViewController()
        welcomeVC.modalPresentationStyle = .fullScreen
        present(welcomeVC, animated: true, completion: nil)
    }

    func showError(_ message: String) {
        print(message)
    }
}
