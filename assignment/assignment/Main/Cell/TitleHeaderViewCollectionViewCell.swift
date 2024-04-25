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
          $0.textColor = UIColor(named: "gray3")
          $0.font = UIFont(name: "Pretendard-Medium", size: 12)
      }
      
      private let arrowIcon = UIImageView().then {
          
          //이미지 sf심볼로 대체
          $0.image = UIImage(systemName: "chevron.right")
          $0.tintColor = UIColor(named: "gray3")
          $0.contentMode = .scaleAspectFit
      }
      
      private let subtitleStackView = UIStackView().then {
          $0.axis = .horizontal
          $0.spacing = 4
          $0.alignment = .center
          $0.distribution = .fill
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
      override init(frame: CGRect) {
          super.init(frame: frame)
          setupViews()
          setupConstraints()
      }
      
      private func setupViews() {
          backgroundColor = .black
          
          contentView.addSubview(titleLabel)
          contentView.addSubview(subtitleStackView)
          
          subtitleStackView.addArrangedSubview(subtitleLabel)
          subtitleStackView.addArrangedSubview(arrowIcon)
      }
      
      private func setupConstraints() {
          titleLabel.snp.makeConstraints {
              $0.top.equalToSuperview().offset(10)
              $0.left.equalToSuperview().offset(10)
          }
          
          subtitleStackView.snp.makeConstraints {
              $0.top.equalToSuperview().offset(10)
              $0.trailing.equalToSuperview().offset(-10)
          }
          
          arrowIcon.snp.makeConstraints {
              $0.width.equalTo(12)
              $0.height.equalTo(12)
          }
      }
      
      func prepare(titleText: String?, subtitleText: String?) {
          titleLabel.text = titleText
          
          if let subtitleText = subtitleText {
              subtitleLabel.text = subtitleText
          }
      }
}
