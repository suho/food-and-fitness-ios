//
//  HomeViewController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 2/15/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import PureLayout

final class HomeViewController: RootSideMenuViewController {
    @IBOutlet fileprivate weak var contentView: UIView!
    @IBOutlet fileprivate weak var nutritionButton: UIButton!
    @IBOutlet fileprivate weak var fitnessButton: UIButton!
    fileprivate var pageController: UIPageViewController!
    lazy var nutritionController: UINavigationController = UINavigationController(rootViewController: NutritionViewController())
    lazy var fitnessController: UINavigationController = UINavigationController(rootViewController: FitnessViewController())

    override func setupUI() {
        super.setupUI()
        configureNavigationBar()
        configurePageController()
    }

    private func configureNavigationBar() {
        title = Strings.home
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

    @IBAction fileprivate func showAddMenu(_ sender: Any) {
        let addMenuController = AddMenuViewController()
        addMenuController.delegate = self
        present(addMenuController, animated: true, completion: nil)
    }
}

// MARK: - AddMenuViewControllerDelegate
extension HomeViewController: AddMenuViewControllerDelegate {
    func viewController(_ viewController: AddMenuViewController, needsPerformAction action: AddMenuViewController.Action) {
        switch action {
        case .addNutrition:
            let addNutrionController = AddNutritionViewController()
            navigationController?.pushViewController(addNutrionController, animated: true)
        case .addFitness:
            let addFitnessController = AddFitnessViewController()
            navigationController?.pushViewController(addFitnessController, animated: true)
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let navi = viewController as? UINavigationController, let _ = navi.visibleViewController as? FitnessViewController {
            return nutritionController
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let navi = viewController as? UINavigationController, let _ = navi.visibleViewController as? NutritionViewController {
            return fitnessController
        }
        return nil
    }
}

// MARK: - UIPageViewControllerDelegate
extension HomeViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            changeStatusButton()
        }
    }
}
