//
//  AnalysisViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/23/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import PureLayout

final class AnalysisViewController: RootSideMenuViewController {
    @IBOutlet fileprivate(set) weak var contentView: UIView!
    @IBOutlet fileprivate(set) weak var nutritionButton: UIButton!
    @IBOutlet fileprivate(set) weak var fitnessButton: UIButton!
    fileprivate var pageController: UIPageViewController!
    lazy var nutritionController: UINavigationController = UINavigationController(rootViewController: NutritionAnalysisController())
    lazy var fitnessController: UINavigationController = UINavigationController(rootViewController: FitnessAnalysisController())

    override func setupUI() {
        super.setupUI()
        configurePageController()
    }

    private func configurePageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.removeFromParentViewController()
        addChildViewController(pageController)
        contentView.removeAllSubviews()
        contentView.addSubview(pageController.view)
        pageController.dataSource = self
        pageController.delegate = self
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        pageController.view.autoPinEdgesToSuperviewEdges()
        pageController.setViewControllers([nutritionController], direction: .forward, animated: false, completion: nil)
    }

    fileprivate func changeStatusButton() {
        nutritionButton.isSelected = !nutritionButton.isSelected
        fitnessButton.isSelected = !fitnessButton.isSelected
    }

    @IBAction fileprivate func nutritionTabClicked(_ sender: Any) {
        if !nutritionButton.isSelected {
            changeStatusButton()
            pageController.setViewControllers([nutritionController], direction: .reverse, animated: true, completion: nil)
        }
    }

    @IBAction fileprivate func fitnessTabClicked(_ sender: Any) {
        if !fitnessButton.isSelected {
            changeStatusButton()
            pageController.setViewControllers([fitnessController], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension AnalysisViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let navi = viewController as? UINavigationController, let _ = navi.visibleViewController as? FitnessAnalysisController {
            return nutritionController
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let navi = viewController as? UINavigationController, let _ = navi.visibleViewController as? NutritionAnalysisController {
            return fitnessController
        }
        return nil
    }
}

// MARK: - UIPageViewControllerDelegate
extension AnalysisViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            changeStatusButton()
        }
    }
}
