//
//  BindingTextField.swift
//  assignment
//
//  Created by 이지훈 on 7/3/24.
//

import Foundation
import UIKit

class BindingTextField : UITextField {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //addtarget에서 메서드 호출
    private func bindViewModel() {
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // 글자 변경시마다 메서드 호출하기
    @objc func textFieldDidChange(_ textfleld: UITextField) {
        if let text = textfleld.text {
            textChanged(text)
        }
    }
    
    //글자 변경시에 클로저 호출
    private var textChanged: (String) -> Void = { _ in }
    
    func binding(callback: @escaping (String) -> Void) {
        self.textChanged = callback
        bindViewModel()
    }
}
