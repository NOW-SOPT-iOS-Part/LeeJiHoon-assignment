//
//  WelcomeViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/12/24.
//

import UIKit
import Then
import SnapKit

class WelcomeViewController: UIViewController {

    
    let imageView = UIImageView().then {
        $0.image = UIImage(named: "tving")
    }
    
    let welcomeLabel = UILabel().then {
        $0.text = "님 반갑습니다."
        $0.textColor = UIColor(named: "gray84")
        $0.font = UIFont(name: "Pretendard-Medium", size: 23)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

}
