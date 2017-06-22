//
//  SignInController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

final class SignInController: BaseViewController {
    @IBOutlet fileprivate(set) weak var mailField: UITextField!
    @IBOutlet fileprivate(set) weak var passField: UITextField!
    @IBOutlet fileprivate(set) weak var signInButton: UIButton!

    var viewModel: SignInViewModel = SignInViewModel(user: nil) {
        didSet {
            updateView()
        }
    }

    override func setupUI() {
        super.setupUI()
        title = Strings.signIn
        mailField.becomeFirstResponder()
    }

    private func updateView() {
        guard isViewLoaded else { return }
        mailField.text = viewModel.mail
        passField.text = viewModel.password
    }

    private func getData() {
        let group = DispatchGroup()
        group.enter()
        viewModel.getUserFoods { [weak self](result) in
            guard self != nil else { return }
            group.leave()
            switch result {
            case .success(_): break
            case .failure(let error):
                HUD.dismiss()
                error.show()
            }
        }
        group.enter()
        viewModel.getUserExercises { [weak self](result) in
            guard self != nil else { return }
            group.leave()
            switch result {
            case .success(_): break
            case .failure(let error):
                HUD.dismiss()
                error.show()
            }
        }
        group.enter()
        viewModel.getTrackings { [weak self](result) in
            guard self != nil else { return }
            group.leave()
            switch result {
            case .success(_): break
            case .failure(let error):
                HUD.dismiss()
                error.show()
            }
        }
        group.enter()
        viewModel.getSuggestions { [weak self](result) in
            guard self != nil else { return }
            group.leave()
            switch result {
            case .success(_): break
            case .failure(let error):
                HUD.dismiss()
                error.show()
            }
        }
        group.notify(queue: .main) {
            HUD.dismiss()
            self.viewDidUpdated()
            AppDelegate.shared.gotoHome()
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func back(_ sender: Any) {
        super.back(sender)
        dismiss(animated: true, completion: nil)
    }

    @IBAction fileprivate func signIn(_ sender: Any) {
        viewModel.mail = mailField.string
        viewModel.password = passField.string
        HUD.show()
        viewModel.signIn { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(_):
                this.getData()
                this.viewDidUpdated()
            case .failure(let error):
                HUD.dismiss()
                this.present(AlertController.alertWithError(error as NSError, level: .require), animated: true, completion: nil)
            }
        }
    }
}
