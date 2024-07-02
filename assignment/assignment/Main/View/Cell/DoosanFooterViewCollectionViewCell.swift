//
//  DoosanFooterViewCollectionViewCell.swift
//  assignment
//
//  Created by 이지훈 on 4/22/24.
//

import UIKit

class DoosanFooterViewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DoosanContent"
    
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
            $0.width.equalTo(190)
            $0.height.equalTo(56)
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

    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(image: UIImage) {
           imageView.image = image
       }
}

