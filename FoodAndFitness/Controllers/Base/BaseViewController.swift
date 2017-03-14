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
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: Strings.BackNavi, style: .plain, target: self, action: nil)
        setupData()
        setupUI()
    }

    func setupData() {
    }
    
    func setupUI() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        view.endEditing(true)
//    }

//    override class func vc() -> Self {
//        let bundle = Bundle.main
//        var xib: String?
//        let name = String(describing: self)
//
//        if bundle.hasNib(name: name) {
//            xib = name
//        }
//        
//        Error.assert(condition: xib != nil, "missing xib `\(name)`")
//
//        return self.init(nibName: xib, bundle: nil)
//    }
}

// MARK: - Action
extension BaseViewController {
    dynamic func back(sender: AnyObject?) {
        _ = navigationController?.popViewController(animated: true)
    }
}
