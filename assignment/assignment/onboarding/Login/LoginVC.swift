//
//  ViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/8/24.
//
import UIKit
import SnapKit
import Then

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var nickname: String?
    
    private var viewModel = LoginViewModel()
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

        loginView.idTextFieldView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        loginView.passwordTextFieldView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        loginView.xCircleButton.addTarget(self, action: #selector(handleXCircleButtonTap), for: .touchUpInside)
        loginView.makeAccount.addTarget(self, action: #selector(presentModalView), for: .touchUpInside)
        loginView.loginButton.addTarget(self, action: #selector(tryLogin), for: .touchUpInside)
    }

    private func bindViewModel() {
        viewModel.isLoginButtonEnabled.bind { [weak self] isEnabled in
            self?.loginView.loginButton.isEnabled = isEnabled
        }
        
        viewModel.loginSuccess.bind { [weak self] success in
            if success {
                self?.navigateToWelcomeScreen()
            } else {
                self?.showError("로그인에 실패하였습니다.")
            }
        }
        
        viewModel.errorMessage.bind { [weak self] message in
            if let msg = message {
                self?.showError(msg)
            }
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.checkValid(id: loginView.idTextFieldView.text, password: loginView.passwordTextFieldView.text)
    }

    @objc func handleXCircleButtonTap() {
        loginView.idTextFieldView.text = ""
        loginView.passwordTextFieldView.text = ""
    }

    @objc func presentModalView() {
        let modalViewController = NicknameViewController()
        present(modalViewController, animated: true, completion: nil)
        modalViewController.onSaveNickname = { [weak self] nickname in
            self?.nickname = nickname
            print("닉네임 저장됨: \(nickname)")
        }
    }

    @objc func tryLogin() {
        viewModel.login()
    }

    func navigateToWelcomeScreen() {
        let welcomeVC = WelcomeViewController()
        present(welcomeVC, animated: true, completion: nil)
    }

    func showError(_ message: String) {
        print(message)
    }
}
