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

    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UnderlineSegmentedControl(items: ["전체", "웹툰", "베스트도전","ㅇㄹ","ㄹㅇ"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()

    private let mainvc = MainViewController()  // Create instance of MainViewController
    private let vc2: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        return vc
    }()
    private let vc3: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        return vc
    }()
    private let vc4: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        return vc
    }()
    private let vc5: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .black
        return vc
    }()

    var dataViewControllers: [UIViewController] {
        [self.mainvc, self.vc2, self.vc3,  self.vc4, self.vc5]
    }
    
    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.pageViewController.view)

        NSLayoutConstraint.activate([
            self.segmentedControl.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.segmentedControl.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.segmentedControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            self.segmentedControl.heightAnchor.constraint(equalToConstant: 50),
        ])

        NSLayoutConstraint.activate([
            self.pageViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 4),
            self.pageViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -4),
            self.pageViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -4),
            self.pageViewController.view.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 5),
        ])

        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.green,
                .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
            ],
            for: .selected
        )

        self.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0  // Default to the first segment
        self.changeValue(control: self.segmentedControl)
    }

    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
}

// Extensions to handle UIPageViewController data source and delegate
extension RootCollectionViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
      ) -> UIViewController? {
        guard
          let index = self.dataViewControllers.firstIndex(of: viewController),
          index - 1 >= 0
        else { return nil }
        return self.dataViewControllers[index - 1]
      }
      
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
      ) -> UIViewController? {
        guard
          let index = self.dataViewControllers.firstIndex(of: viewController),
          index + 1 < self.dataViewControllers.count
        else { return nil }
        return self.dataViewControllers[index + 1]
      }

      func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
      ) {
        guard
          let viewController = pageViewController.viewControllers?[0],
          let index = self.dataViewControllers.firstIndex(of: viewController)
        else { return }
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
      }
    }

#Preview {
    RootCollectionViewController()
}
