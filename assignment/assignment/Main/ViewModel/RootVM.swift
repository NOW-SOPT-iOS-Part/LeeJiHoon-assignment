//
//  MainVM.swift
//  assignment
//
//  Created by 이지훈 on 6/3/24.
//

import UIKit

class RootViewModel {
    var segmentTitles: [String] = ["홈", "실시간", "TV프로그램", "영화", "파라마운트+"]
    
    var mainViewController: MainViewController? = nil
    
    var selectedSegmentIndex: Int = 0 {
        didSet {
            onPageChanged?(selectedSegmentIndex)
        }
    }
    
    var onPageChanged: ((Int) -> Void)?
    
    var numberOfSegments: Int {
        return segmentTitles.count
    }
    
    func titleForSegment(at index: Int) -> String {
        return segmentTitles[index]
    }
    
    func viewControllerForSegment(at index: Int) -> UIViewController {
        switch index {
        case 0:
            if mainViewController == nil {
                mainViewController = MainViewController()
            }
            return mainViewController!
        case 1:
            let vc = UIViewController()
            vc.view.backgroundColor = .green
            return vc
        case 2:
            let vc = UIViewController()
            vc.view.backgroundColor = .blue
            return vc
        case 3:
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            return vc
        case 4:
            let vc = UIViewController()
            vc.view.backgroundColor = .black
            return vc
        default:
            return UIViewController()
        }
    }
    
    func getSegmentTitles() -> [String] {
        return segmentTitles
    }
    
    func getMainViewController() -> MainViewController? {
        return mainViewController
    }
}
