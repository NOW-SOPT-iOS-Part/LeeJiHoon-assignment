//
//  MainVM.swift
//  assignment
//
//  Created by 이지훈 on 6/3/24.
//

import UIKit

class RootViewModel: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private let segmentTitles: [String] = ["홈", "실시간", "TV프로그램", "영화", "파라마운트+"]
    private let viewControllers: [UIViewController] = [
        MainViewController(),
        UIViewController().then { $0.view.backgroundColor = .green },
        UIViewController().then { $0.view.backgroundColor = .blue },
        UIViewController().then { $0.view.backgroundColor = .white },
        UIViewController().then { $0.view.backgroundColor = .black }
    ]
    
    var onPageChanged: ((Int) -> Void)?

    var currentPage: Int = 0 {
        didSet {
            onPageChanged?(currentPage)
        }
    }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView, navigationController: UINavigationController?) {
        let offset = scrollView.contentOffset.y
        let isScrollingDown = offset > 0
        navigationController?.setNavigationBarHidden(isScrollingDown, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, footerViewUpdateHandler: (IndexPath, Int, Int) -> Void) {
        if let mainvc = mainViewController(), let visibleIndexPath = mainvc.mainCollectionView.indexPathForItem(at: CGPoint(x: mainvc.mainCollectionView.contentOffset.x + mainvc.mainCollectionView.bounds.width / 2, y: mainvc.mainCollectionView.contentOffset.y + mainvc.mainCollectionView.bounds.height / 2)) {
            let numberOfItems = mainvc.mainCollectionView.numberOfItems(inSection: visibleIndexPath.section)
            footerViewUpdateHandler(visibleIndexPath, numberOfItems, visibleIndexPath.item)
        }
    }
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return viewControllerBefore(viewController: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return viewControllerAfter(viewController: viewController)
    }
    
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let viewController = pageViewController.viewControllers?.first, let index = viewControllers.firstIndex(of: viewController) else { return }
        setSelectedSegmentIndex(index)
    }
}
