//
//  RootCollectionViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/29/24.
//
import UIKit

import SnapKit
import Then

class RootCollectionViewController: UIViewController {
    
    private let viewModel = RootViewModel()
    
    private lazy var segmentedControl: UnderlineSegmentedControl = {
        let control = UnderlineSegmentedControl(items: viewModel.getSegmentTitles()).then {
            $0.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
            $0.backgroundColor = .clear
        }
        return control
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.delegate = self
        vc.dataSource = self
        return vc
    }()
    
    var dataViewControllers: [UIViewController] {
        (0..<viewModel.numberOfSegments).map { viewModel.viewControllerForSegment(at: $0) }
    }
    
    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers([dataViewControllers[self.currentPage]], direction: direction, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        viewModelBinding()
      
    }
    
    private func viewModelBinding() {
        viewModel.onPageChanged = { [weak self] index in
            self?.updatePage(to: index)
        }
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupSegmentsAndPageView()
        setupConstraints()
        setupInitialState()
        
        DispatchQueue.main.async { [weak self] in
            self?.setupCollectionViewDelegate()
        }
    }
    
    private func setupNavigationBar() {
        let leftImage = UIImage(named: "leftTving")
        let leftButtonItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = leftButtonItem
        
        let rightImage = UIImage(named: "rightImage")
        let rightButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    private func setupSegmentsAndPageView() {
        view.addSubview(segmentedControl)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        view.bringSubviewToFront(segmentedControl)
    }
    
    private func setupConstraints() {
        segmentedControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(50)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupInitialState() {
        segmentedControl.selectedSegmentIndex = 0
        changeValue(control: segmentedControl)
    }
    
    private func setupCollectionViewDelegate() {
        if let mainvc = viewModel.getMainViewController() {
            mainvc.mainCollectionView.delegate = self
        }
    }
    
    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
    
    private func updatePage(to index: Int) {
        let direction: UIPageViewController.NavigationDirection = segmentedControl.selectedSegmentIndex <= index ? .forward : .reverse
        pageViewController.setViewControllers([viewModel.viewControllerForSegment(at: index)], direction: direction, animated: true, completion: nil)
        segmentedControl.selectedSegmentIndex = index
    }
}

extension RootCollectionViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.dataViewControllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        return self.dataViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.dataViewControllers.firstIndex(of: viewController), index + 1 < self.dataViewControllers.count else { return nil }
        return self.dataViewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let viewController = pageViewController.viewControllers?.first, let index = self.dataViewControllers.firstIndex(of: viewController) else { return }
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
    }
}

extension RootCollectionViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let isScrollingDown = offset > 0
        
        navigationController?.setNavigationBarHidden(isScrollingDown, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let mainvc = viewModel.getMainViewController() else { return }
        
        let visibleIndexPath = mainvc.mainCollectionView.indexPathForItem(at: CGPoint(x: mainvc.mainCollectionView.contentOffset.x + mainvc.mainCollectionView.bounds.width / 2, y: mainvc.mainCollectionView.contentOffset.y + mainvc.mainCollectionView.bounds.height / 2))
        
        if let visibleIndexPath = visibleIndexPath, let footerView = mainvc.mainCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: visibleIndexPath.section)) as? CustomFooterView {
            footerView.configure(numberOfPages: mainvc.mainCollectionView.numberOfItems(inSection: visibleIndexPath.section), currentPage: visibleIndexPath.item)
        }
    }
}
