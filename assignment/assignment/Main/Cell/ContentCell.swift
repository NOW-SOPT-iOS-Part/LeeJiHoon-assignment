//
//  ContentCell.swift
//  assignment
//
//  Created by 이지훈 on 4/22/24.
//

import UIKit
import SnapKit
import Then


class ContentCell: UICollectionViewCell {
    
    static let identifier = "ContentCell"
    
    var isFullWidth = false {
            didSet {
                updateLayoutForFullWidth()
            }
        }

        private let imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
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
        contentView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(10)
            $0.width.equalTo(98)
            $0.height.equalTo(148)
        }
        
        
    }
    
    private func updateLayoutForFullWidth() {
        imageView.snp.remakeConstraints {
            if isFullWidth {
                $0.edges.equalToSuperview()
            } else {
                $0.top.equalToSuperview().inset(10)
                $0.width.equalToSuperview()
                $0.height.equalTo(148)
            }
        }
    }

    func configure(image: UIImage, title: String, isFullWidth: Bool = false) {
        self.isFullWidth = isFullWidth
        imageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func mainCollectionConfigure(image: UIImage, title: String) {
        imageView.image = image
    }
}

