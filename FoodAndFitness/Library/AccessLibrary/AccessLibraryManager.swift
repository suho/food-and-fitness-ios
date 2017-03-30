//
//  AccessLibraryManager.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 6/30/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import UIKit

enum AccessLibraryType {
    case photo
    case camera
}

protocol AccessLibraryManagerDelegate: NSObjectProtocol {
    func accessLibraryManager(manager: AccessLibraryManager, didFinishPickingWithImage image: UIImage, type: AccessLibraryType)
}

private var manager: AccessLibraryManager! = nil

final class AccessLibraryManager: NSObject {

    weak var delegate: AccessLibraryManagerDelegate?
    fileprivate var type: AccessLibraryType = .camera

    override init() {
        super.init()
    }

    // MARK: - Public
    func openPhoto(sender: AnyObject?) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            type = .photo
            present(pickerController: imagePicker)
        } else {
            // can't access
        }
    }

    func openCamera(sender: AnyObject?) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            type = .camera
            present(pickerController: imagePicker)
        } else {
            // can't access
        }
    }

    // MARK: - Private
    private func present(pickerController: UIImagePickerController?) {
        guard let picker = pickerController else { return }
        guard let window = UIApplication.shared.delegate?.window else { return }
        guard let root = window?.rootViewController else { return }
        manager = self
        root.present(picker, animated: true, completion: nil)
    }

    fileprivate func dismiss(pickerController: UIImagePickerController?) {
        guard let picker = pickerController else { return }
        picker.dismiss(animated: true) {
            manager = nil
        }
    }
}

// MARK: - ImagePicker, NavigationController Delegate
extension AccessLibraryManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {

        if picker.sourceType == .camera {
            guard let originImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
            UIImageWriteToSavedPhotosAlbum(originImage, nil, nil, nil)
        }

        guard let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        delegate?.accessLibraryManager(manager: self, didFinishPickingWithImage: editedImage, type: type)
        dismiss(pickerController: picker)
    }
}
