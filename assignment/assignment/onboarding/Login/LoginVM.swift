//
//  LoginVm.swift
//  assignment
//
//  Created by 이지훈 on 5/27/24.
//
import Foundation

class LoginViewModel {
    
    var id = ObservablePattern("")
    var password = ObservablePattern("")
    var nickname: String?
    
    var isLoginButtonEnabled = ObservablePattern(false)
    var loginSuccess = ObservablePattern(false)
    var errorMessage = ObservablePattern<String?>(nil)
    
    init() {
        bindInputs()
    }

    private func bindInputs() {
        id.bind { [weak self] id in
            self?.validateCredentials()
        }
        
        password.bind { [weak self] password in
            self?.validateCredentials()
        }
    }

    private func validateCredentials() {
        let isValidId = validateId(id.value)
        let isValidPassword = validatePassword(password.value)
        
        isLoginButtonEnabled.value = (isValidId == nil && isValidPassword == nil)
    }
    
    func login() {
        if validateId(id.value) == nil && validatePassword(password.value) == nil {
            loginSuccess.value = true
            errorMessage.value = nil
            nickname = id.value // 로그인 성공 시 사용자 아이디를 닉네임으로 설정
        } else {
            errorMessage.value = "아이디 또는 비밀번호 형식이 올바르지 않습니다."
            loginSuccess.value = false
        }
    }

    func checkValid(id: String?, password: String?) {
        guard let id = id, !id.isEmpty, let password = password, !password.isEmpty else {
            errorMessage.value = "ID와 비밀번호를 모두 입력해주세요."
            return
        }

        let validId = validateId(id)
        let validPassword = validatePassword(password)
        
        if validId == nil && validPassword == nil {
            loginSuccess.value = true
            errorMessage.value = nil
        } else {
            errorMessage.value = "입력된 ID 또는 비밀번호가 형식에 맞지 않습니다."
            loginSuccess.value = false
        }
    }

    private func validateId(_ id: String) -> String? {
        guard id.range(of: "[A-Za-z0-9]{5,13}", options: .regularExpression) != nil else {
            return "아이디가 유효하지 않습니다."
        }
        return nil
    }

    private func validatePassword(_ password: String) -> String? {
        guard password.range(of: "[A-Za-z0-9!_@$%^&+=]{8,20}", options: .regularExpression) != nil else {
            return "비밀번호가 유효하지 않습니다."
        }
        return nil
    }
}
