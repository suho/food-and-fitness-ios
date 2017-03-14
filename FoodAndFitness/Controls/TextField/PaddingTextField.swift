//
//  PaddingTextField.swift
//  CM
//
//  Created by HaiPhung on 6/24/16.
//  Copyright © 2016 AsianTech Co., Ltd. All rights reserved.
//

import UIKit

@IBDesignable
class PaddingTextField: UITextField, UITextFieldDelegate {

    @IBInspectable var inset: CGFloat = 15
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: inset, y: 0, width: bounds.width - 2 * inset, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
