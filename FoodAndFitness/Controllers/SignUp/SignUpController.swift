//
//  SignUpController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/5/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

class SignUpController: BaseViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    var viewModel: SignUpViewModel!

    enum SignUpRow: Int {
        case avatar
        case fullName
        case email
        case password
        case confirmPassword
        case informationTitle
        case birthday
        case gender
        case height
        case weight
        case button

        static var count: Int {
            return self.button.hashValue + 1
        }

        var title: String {
            switch self {
            case .avatar:
                return Strings.avatar
            case .fullName:
                return Strings.fullName
            case .email:
                return Strings.email
            case .password:
                return Strings.password
            case .confirmPassword:
                return Strings.confirmPassword
            case .informationTitle:
                return Strings.informationTitle
            case .birthday:
                return Strings.birthday
            case .gender:
                return Strings.gender
            case .height:
                return Strings.height
            case .weight:
                return Strings.weight
            case .button:
                return Strings.empty
            }
        }

        var heightForRow: CGFloat {
            switch self {
            case .avatar:
                return 100
            case .informationTitle:
                return 60
            default:
                return 55

            }
        }
    }

    override func setupUI() {
        super.setupUI()
        title = Strings.signUp
        configureTableView()
    }

    private func configureTableView() {
        tableView.register(TitleCell.self)
        tableView.register(AvatarCell.self)
        tableView.register(InputCell.self)
        tableView.register(RadioCell.self)
        tableView.register(NextButtonCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension SignUpController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SignUpRow.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = SignUpRow(rawValue: indexPath.row) else { fatalError(Strings.Errors.enumError) }
        switch row {
        case .avatar:
            let cell = tableView.dequeue(AvatarCell.self)
            cell.data = AvatarCell.Data(title: Strings.avatar, image: viewModel.signUpParams.avatar)
            cell.delegate = self
            return cell
        case .fullName:
            let cell = tableView.dequeue(InputCell.self)
            cell.data = InputCell.Data(title: Strings.fullName,
                                       placeHolder: Strings.fullName,
                                       detailText: viewModel.signUpParams.fullName)
            cell.delegate = self
            cell.cellType = row
            return cell
        case .email:
            let cell = tableView.dequeue(InputCell.self)
            cell.data = InputCell.Data(title: Strings.email,
                                       placeHolder: Strings.email,
                                       detailText: viewModel.signUpParams.email)
            cell.delegate = self
            cell.cellType = row
            return cell
        case .password:
            let cell = tableView.dequeue(InputCell.self)
            cell.data = InputCell.Data(title: Strings.password,
                                       placeHolder: Strings.password,
                                       detailText: viewModel.signUpParams.password)
            cell.delegate = self
            cell.cellType = row
            return cell
        case .confirmPassword:
            let cell = tableView.dequeue(InputCell.self)
            cell.data = InputCell.Data(title: Strings.confirmPassword,
                                       placeHolder: Strings.confirmPassword,
                                       detailText: viewModel.signUpParams.confirmPassword)
            cell.delegate = self
            cell.cellType = row
            return cell
        case .informationTitle:
            let cell = tableView.dequeue(TitleCell.self)
            cell.data = TitleCell.Data(title: Strings.informationTitle)
            return cell
        case .birthday:
            let cell = tableView.dequeue(InputCell.self)
            cell.data = InputCell.Data(title: Strings.birthday,
                                       placeHolder: Strings.birthday,
                                       detailText: viewModel.signUpParams.birthday)
            cell.delegate = self
            cell.cellType = row
            return cell
        case .gender:
            let cell = tableView.dequeue(RadioCell.self)
            cell.data = RadioCell.Data(title: Strings.gender)
            cell.delegate = self
            return cell
        case .height:
            let cell = tableView.dequeue(InputCell.self)
            cell.data = InputCell.Data(title: Strings.height,
                                       placeHolder: Strings.height,
                                       detailText: viewModel.signUpParams.height.toString())
            cell.delegate = self
            cell.cellType = row
            return cell
        case .weight:
            let cell = tableView.dequeue(InputCell.self)
            cell.data = InputCell.Data(title: Strings.weight,
                                       placeHolder: Strings.weight,
                                       detailText: viewModel.signUpParams.weight.toString())
            cell.delegate = self
            cell.cellType = row
            return cell
        case .button:
            let cell = tableView.dequeue(NextButtonCell.self)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SignUpController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = SignUpRow(rawValue: indexPath.row) else { fatalError(Strings.Errors.enumError) }
        return row.heightForRow
    }
}

// MARK: - AvatarCellDelegate
extension SignUpController: AvatarCellDelegate {
    func cell(_ cell: AvatarCell, needsPerformAction action: AvatarCell.Action) {
        let accessLibrary = AccessLibraryManager()
        accessLibrary.delegate = self
        switch action {
        case .showActionSheet:
            let alert = AlertController(title: App.name, message: Strings.choosePhotoAction, preferredStyle: .actionSheet)
            alert.addAction(Strings.openGallery, handler: {
                accessLibrary.openPhoto(sender: nil)
            })
            alert.addAction(Strings.openCamera, handler: { 
                accessLibrary.openCamera(sender: nil)
            })
            alert.addAction(Strings.cancel, style: .cancel, handler: nil)
            alert.present()
        }
    }
}

// MARK: - AccessLibraryManager
extension SignUpController: AccessLibraryManagerDelegate {
    func accessLibraryManager(manager: AccessLibraryManager, didFinishPickingWithImage image: UIImage, type: AccessLibraryType) {
        viewModel.signUpParams.avatar = image
        tableView.reloadData()
    }
}

// MARK: - NextButtonCellDelegate
extension SignUpController: NextButtonCellDelegate {
    func cell(_ cell: NextButtonCell, needsPerformAction action: NextButtonCell.Action) {
        
    }
}

// MARK: - RadioCellDelegate
extension SignUpController: RadioCellDelegate {
    func cell(_ cell: RadioCell, didSelectGender gender: Gender) {
        viewModel.signUpParams.gender = gender.rawValue
    }
}

// MARK: - InputCellDelegate
extension SignUpController: InputCellDelegate {
    func cell(_ cell: InputCell, withInputString string: String) {
        switch cell.cellType {
        case .fullName:
            viewModel.signUpParams.fullName = string
        case .email:
            viewModel.signUpParams.email = string
        case .password:
            viewModel.signUpParams.password = string
        case .confirmPassword:
            viewModel.signUpParams.confirmPassword = string
        case .birthday:
            viewModel.signUpParams.birthday = string
        case .height:
            if let height = Int(string) {
                viewModel.signUpParams.height = height
            }
        case .weight:
            if let weight = Int(string) {
                viewModel.signUpParams.weight = weight
            }
        default: break
        }
    }
}
