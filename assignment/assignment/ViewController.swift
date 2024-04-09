//
//  ViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/8/24.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {

    let LoginLabel = UILabel().then {
        $0.text = "TVING ID 로그인"
        $0.textColor = UIColor(named: "gray84")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brown
    }


}
//
//#Preview{
//    ViewController()
//}
