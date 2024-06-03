//
//  MainVM.swift
//  assignment
//
//  Created by 이지훈 on 6/3/24.
//

import UIKit
// RootViewModel.swift
import UIKit

class RootViewModel {
    private let segmentTitles: [String] = ["홈", "실시간", "TV프로그램", "영화", "파라마운트+"]
    let viewControllers: [UIViewController] = [
        MainViewController(),
        UIViewController().then { $0.view.backgroundColor = .green },
        UIViewController().then { $0.view.backgroundColor = .blue },
        UIViewController().then { $0.view.backgroundColor = .white },
        UIViewController().then { $0.view.backgroundColor = .black }
    ]
    
    var currentPage: Int = 0 {
        didSet {
            onPageChanged?(currentPage)
        }
    }
    
    var onPageChanged: ((Int) -> Void)?
    
    var numberOfSegments: Int {
        return segmentTitles.count
    }
    
    func getSegmentTitles() -> [String] {
        return segmentTitles
    }
    
    func viewControllerForSegment(at index: Int) -> UIViewController {
        return viewControllers[index]
    }
    
    func setSelectedSegmentIndex(_ index: Int) {
        currentPage = index
    }
    
    func mainViewController() -> MainViewController? {
        return viewControllers[0] as? MainViewController
    }
    
    func viewControllerBefore(viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        return viewControllers[index - 1]
    }
    
    func viewControllerAfter(viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index + 1 < viewControllers.count else { return nil }
        return viewControllers[index + 1]
    }
    
    func updatePage(to index: Int, completion: @escaping (UIViewController, UIPageViewController.NavigationDirection) -> Void) {
        let direction: UIPageViewController.NavigationDirection = currentPage <= index ? .forward : .reverse
        let viewController = viewControllers[index]
        currentPage = index
        completion(viewController, direction)
    }
}
