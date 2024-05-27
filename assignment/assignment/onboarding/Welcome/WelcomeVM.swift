//
//  WelcomeVM.swift
//  assignment
//
//  Created by 이지훈 on 5/27/24.
//

import Foundation

protocol WelcomeViewModelType {
    var id: ObservablePattern<String> { get }
    var nickname: ObservablePattern<String?> { get }
    var welcomeMessage: ObservablePattern<String> { get }
    
    func configureWelcomeMessage()
}

final class WelcomeViewModel: WelcomeViewModelType {
    var id: ObservablePattern<String> = ObservablePattern<String>("")
    var nickname: ObservablePattern<String?> = ObservablePattern<String?>(nil)
    var welcomeMessage: ObservablePattern<String> = ObservablePattern<String>("")
    
    func configureWelcomeMessage() {
        if let nickname = nickname.value {
            welcomeMessage.value = "\(nickname)님\n 반가워요!"
        } else {
            welcomeMessage.value = "\(id.value)님\n 반가워요!"
        }
    }
}
