//
//  CarouselCollectionViewCell.swift
//  assignment
//
//  Created by 이지훈 on 4/25/24.
//

import UIKit
import SnapKit
import Then

class CustomFooterView: UICollectionReusableView {
    static let identifier = "FooterView"

    private let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .gray3  // 선택된 페이지 색상
        $0.pageIndicatorTintColor = .gray1         // 비선택 페이지 색상
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(numberOfPages: Int, currentPage: Int) {
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
    }
}

