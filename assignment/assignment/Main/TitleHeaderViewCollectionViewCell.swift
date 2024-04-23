//
//  TitleHeaderViewCollectionViewCell.swift
//  assignment
//
//  Created by 이지훈 on 4/22/24.
//

import UIKit
import Then
import SnapKit

class TitleHeaderViewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleHeaderViewCollectionViewCell"

    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 15)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(10)
        }
        
        self.subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            $0.left.equalToSuperview().offset(10)
        }
    }
    
    
    func prepare(titleText: String?, subtitleText: String?) {
        
        if let titleText = titleText {
            self.titleLabel.text = titleText
        }
        
        if let subtitleText = subtitleText {
            self.subtitleLabel.text = subtitleText
        }
      self.titleLabel.text = titleText
    }
  
}
