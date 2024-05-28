//
//  LoginVm.swift
//  assignment
//
//  Created by 이지훈 on 5/27/24.
//

import Foundation

protocol LoginViewModelType {
    var isValid: ObservablePattern<Bool> { get }
    var errMessage: ObservablePattern<String?> { get }
    
    func checkValid(id: String?, password: String?)
}

final class LoginViewModel: LoginViewModelType {
    var isValid: ObservablePattern<Bool> = ObservablePattern<Bool>(false)
    var errMessage: ObservablePattern<String?> = ObservablePattern<String?>(nil)
    
    func checkValid(id: String?, password: String?) {
        guard let id = id else {
            errMessage.value = "아이디가 비어있습니다."
            isValid.value = false
            return
        }
        guard let password = password else {
            errMessage.value = "비밀번호가 비어있습니다."
            isValid.value = false
            return
        }
        
        let idRegEx = "[A-Za-z0-9]{5,13}"
        let pwRegEx = "[A-Za-z0-9!_@$%^&+=]{8,20}"
        
        let isIdValid = id.range(of: idRegEx, options: .regularExpression) != nil
        let isPasswordValid = password.range(of: pwRegEx, options: .regularExpression) != nil
        
        print("ID 입력 값: \(id), 유효성 검사 결과: \(isIdValid)")
        print("비밀번호 입력 값: \(password), 유효성 검사 결과: \(isPasswordValid)") 
        
        guard isIdValid else {
            errMessage.value = "아이디가 유효하지 않습니다."
            isValid.value = false
            return
        }
        
        guard isPasswordValid else {
            errMessage.value = "비밀번호가 유효하지 않습니다."
            isValid.value = false
            return
        }
        
        isValid.value = true
        errMessage.value = nil
    }

    
    
}
