//
//  WelcomeVM.swift
//  assignment
//
//  Created by 이지훈 on 5/27/24.
//
import Foundation

import RxSwift
import RxCocoa

protocol WelcomeViewModelType {
    var id: BehaviorRelay<String> { get }
    var nickname: BehaviorRelay<String?> { get }
    var welcomeMessage: BehaviorRelay<String> { get }
    
    func configureWelcomeMessage()
}

class WelcomeViewModel: WelcomeViewModelType {
    var id = BehaviorRelay<String>(value: "")
    var nickname = BehaviorRelay<String?>(value: "")
    var welcomeMessage = BehaviorRelay<String>(value: "Loading...")

    private let disposeBag = DisposeBag()

    init() {
        Observable.combineLatest(id.asObservable(), nickname.asObservable())
            .map { id, nickname in
                if let nickname = nickname {
                    return "\(nickname)님\n 반가워요!"
                } else {
                    return "\(id)님\n 반가워요!"

                }
            }
            .bind(to: welcomeMessage)
            .disposed(by: disposeBag)
    }
    
    func configureWelcomeMessage() {
        let message = nickname.value.map { "\($0)님\n 반가워요!" } ?? "\(id.value)님\n 반가워요!"
        welcomeMessage.accept(message)
    }
}
