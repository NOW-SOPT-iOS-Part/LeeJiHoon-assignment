//
//  underlineSegment.swift
//  assignment
//
//  Created by 이지훈 on 4/28/24.
//

import Foundation
import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {
    // 언더라인을 표시할 뷰
    private lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white // 언더라인 색상 설정
        self.addSubview(view) // 언더라인 뷰를 세그먼트 컨트롤에 추가
        return view
    }()
    
    // 프레임을 사용하여 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.removeBackgroundAndDivider()
    }
    
    // 항목 배열을 사용하여 초기화
    override init(items: [Any]?) {
        super.init(items: items)
        self.removeBackgroundAndDivider()
    }
    
    // NSCoder를 사용한 초기화는 지원하지 않음
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 세그먼트 컨트롤의 배경 및 구분선 제거
    private func removeBackgroundAndDivider() {
        let image = UIImage() // 빈 이미지 생성
        // 모든 상태에 대해 빈 이미지를 배경으로 설정
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        // 구분선 제거
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // 레이아웃 서브뷰 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUnderlinePosition() // 언더라인 위치 업데이트
    }
    
    // 언더라인의 위치를 업데이트
    private func updateUnderlinePosition() {
        guard numberOfSegments > 0, selectedSegmentIndex >= 0, selectedSegmentIndex < numberOfSegments else {
            return
        }

        let segmentWidth = self.frame.width / CGFloat(self.numberOfSegments) // 세그먼트 너비
        let selectedIndex = CGFloat(self.selectedSegmentIndex) // 선택된 인덱스
        let textWidth = calculateTextWidthForSegment(at: selectedIndex) // 선택된 세그먼트의 텍스트 너비

        // 언더라인의 X 위치 계산
        let xPosition = segmentWidth * selectedIndex + (segmentWidth - textWidth) / 2
        let yPosition = self.bounds.size.height - 2.0 // 언더라인의 Y 위치
        let height = 3.0 // 언더라인의 높이

        // 언더라인 뷰 애니메이션으로 위치 업데이트
        UIView.animate(withDuration: 0.1) {
            self.underlineView.frame = CGRect(x: xPosition, y: yPosition, width: textWidth, height: height)
        }
    }

    
    // 세그먼트의 텍스트 너비를 계산
    func calculateTextWidthForSegment(at index: CGFloat) -> CGFloat {
        guard let segmentTitle = self.titleForSegment(at: Int(index)) as NSString? else { return 0 }
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Pretendard-Regular", size: 14)] // 폰트 속성
        let textWidth = segmentTitle.size(withAttributes: attributes).width // 텍스트 너비 계산
        return textWidth
    }
    
}
