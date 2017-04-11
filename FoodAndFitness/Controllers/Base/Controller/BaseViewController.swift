//
//  AppDelegate.swift
//  BaseViewController
//
//  Created by Mylo Ho on 2/15/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

class BaseViewController: ViewController {

    var isVisible = false

    var isNavigationBarHidden: Bool {
        return false
    }

    override required init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setup() {
        super.setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = isNavigationBarHidden
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: Strings.backNavi, style: .plain, target: self, action: #selector(back))
        setupData()
        setupUI()
    }

    func setupData() {
    }
    
    func setupUI() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = isNavigationBarHidden
        isVisible = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isVisible = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }

    func loadData() {
        guard isViewFirstAppear else { return }
    }
}

// MARK: - Action
extension BaseViewController {
    @IBAction dynamic func back(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}
