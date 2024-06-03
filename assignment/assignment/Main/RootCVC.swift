//
//  RootCollectionViewController.swift
//  assignment
//
//  Created by 이지훈 on 4/29/24.
//
// RootCollectionViewController.swift
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        viewModelBinding()
    }
    
    private func viewModelBinding() {
        viewModel.onPageChanged = { [weak self] index in
            self?.segmentedControl.selectedSegmentIndex = index
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.setupCollectionViewDelegate()
        }
        
        viewModel.updatePage(to: 0) { [weak self] viewController, direction in
            self?.pageViewController.setViewControllers([viewController], direction: direction, animated: false, completion: nil)
        }
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupSegmentsAndPageView()
        setupConstraints()
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
    
    private func setupCollectionViewDelegate() {
        if let mainvc = viewModel.mainViewController() {
            mainvc.mainCollectionView.delegate = self
        }
    }
    
    @objc private func changeValue(control: UISegmentedControl) {
        viewModel.setSelectedSegmentIndex(control.selectedSegmentIndex)
        viewModel.updatePage(to: control.selectedSegmentIndex) { [weak self] viewController, direction in
            self?.pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
        }
    }
}

extension RootCollectionViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return viewModel.viewControllerBefore(viewController: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return viewModel.viewControllerAfter(viewController: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let viewController = pageViewController.viewControllers?.first, let index = viewModel.viewControllers.firstIndex(of: viewController) else { return }
        viewModel.setSelectedSegmentIndex(index)
    }
}

extension RootCollectionViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let isScrollingDown = offset > 0
        navigationController?.setNavigationBarHidden(isScrollingDown, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let mainvc = viewModel.mainViewController(), let visibleIndexPath = mainvc.mainCollectionView.indexPathForItem(at: CGPoint(x: mainvc.mainCollectionView.contentOffset.x + mainvc.mainCollectionView.bounds.width / 2, y: mainvc.mainCollectionView.contentOffset.y + mainvc.mainCollectionView.bounds.height / 2)), let footerView = mainvc.mainCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: visibleIndexPath.section)) as? CustomFooterView {
            footerView.configure(numberOfPages: mainvc.mainCollectionView.numberOfItems(inSection: visibleIndexPath.section), currentPage: visibleIndexPath.item)
        }
    }
}
