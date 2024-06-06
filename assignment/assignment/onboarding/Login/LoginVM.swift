//
//  LoginVm.swift
//  assignment
//
//  Created by 이지훈 on 5/27/24.
//
import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelType {
    var id: BehaviorSubject<String> { get }
    var idInput: AnyObserver<String> { get }
    var passwordInput: AnyObserver<String> { get }
    var isLoginButtonEnabled: Observable<Bool> { get }
    var loginSuccess: Observable<Bool> { get }
    var errorMessage: Observable<String?> { get }
    var isValid: Observable<Bool> { get }
    var nickname: String? { get set }

    func login()
    func checkValid(id: String?, password: String?)
}


class LoginViewModel: LoginViewModelType {
    
    var id = BehaviorSubject<String>(value: "")
    private let disposeBag = DisposeBag()
    var nickname: String?
    
    // BehaviorSubject를 사용하여 초기 값 설정과 동시에 최신 값 유지
    private let idInputSubject = BehaviorSubject<String>(value: "")
    private let passwordInputSubject = BehaviorSubject<String>(value: "")
    
    // 로그인 성공 및 에러 메시지를 위한 PublishSubject
    private let loginSuccessSubject = PublishSubject<Bool>()
    private let errorMessageSubject = PublishSubject<String?>()
    
    // 입력값에 대한 AnyObserver 제공
    var idInput: AnyObserver<String> {
        return idInputSubject.asObserver()
    }
    
    var passwordInput: AnyObserver<String> {
        return passwordInputSubject.asObserver()
    }
    
    // 로그인 버튼 활성화 여부
    var isLoginButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(idInputSubject, passwordInputSubject)
            .map { id, password in
                !id.isEmpty && !password.isEmpty && id.range(of: "[A-Za-z0-9]{5,13}", options: .regularExpression) != nil &&
                password.range(of: "[A-Za-z0-9!_@$%^&+=]{8,20}", options: .regularExpression) != nil
            }
    }
    
    // 로그인 성공 여부
    // 로그인 성공 여부
    var loginSuccess: Observable<Bool> {
        return loginSuccessSubject.asObservable()
    }

  

    // 에러 메시지
    var errorMessage: Observable<String?> {
        return errorMessageSubject.asObservable()
    }
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(idInputSubject, passwordInputSubject) { id, password in
            return !id.isEmpty && !password.isEmpty
        }
    }
    
    init() {
        // 입력값의 유효성 검사 후 로그인 버튼 활성화 상태 결정
        isLoginButtonEnabled
            .observe(on: MainScheduler.asyncInstance) // 여기서 비동기 처리를 지정
            .subscribe(onNext: { isEnabled in
                print("로그인 버튼 활성화 상태: \(isEnabled)")
            })
            .disposed(by: disposeBag)
        
        loginSuccess
            .filter { $0 == true }
            .flatMapLatest { [unowned self] _ -> Observable<String> in
                self.idInputSubject
            }
            .subscribe(onNext: { [weak self] id in
                self?.id.onNext(id)
                self?.nickname = id
                print("로그인 성공: \(id)")
            })
            .disposed(by: disposeBag)
    }
    
    // ViewModel 내에서 로그인을 시도하고 성공/실패를 Observable로 알림
    func login() {
        guard let id = try? idInputSubject.value(), let password = try? passwordInputSubject.value(),
              !id.isEmpty, !password.isEmpty else {
            errorMessageSubject.onNext("ID 또는 비밀번호가 비어 있습니다.")
            loginSuccessSubject.onNext(false)
            return
        }
        
        if validateId(id) != nil || validatePassword(password) != nil {
            errorMessageSubject.onNext("아이디 또는 비밀번호 형식이 올바르지 않습니다.")
            loginSuccessSubject.onNext(false)
        } else {
            loginSuccessSubject.onNext(true)
            errorMessageSubject.onNext(nil)
            self.nickname = id // 아이디를 닉네임으로 설정
            self.id.onNext(id) // 아이디 BehaviorSubject 업데이트
            print("넘긴 id값은 \(id) 입니다.")
        }
    }

    func checkValid(id: String?, password: String?) {
        guard let id = id, let password = password, !id.isEmpty, !password.isEmpty else {
            errorMessageSubject.onNext("ID 또는 비밀번호를 입력해주세요.")
            return
        }
        
        if validateId(id) == nil || validatePassword(password) == nil {
            errorMessageSubject.onNext("입력한 ID 또는 비밀번호가 형식에 맞지 않습니다.")
        } else {
            errorMessageSubject.onNext(nil)  // 유효성 검사 통과
        }
    }
    
    // ID 검증 메소드
    private func validateId(_ id: String) -> String? {
        guard id.range(of: "[A-Za-z0-9]{5,13}", options: .regularExpression) != nil else {
            return "아이디가 유효하지 않습니다."
        }
        return nil
    }
    
    // 비밀번호 검증 메소드
    private func validatePassword(_ password: String) -> String? {
        guard password.range(of: "[A-Za-z0-9!_@$%^&+=]{8,20}", options: .regularExpression) != nil else {
            return "비밀번호가 유효하지 않습니다."
        }
        return nil
    }
}
