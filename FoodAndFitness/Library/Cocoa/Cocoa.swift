//
//  Cocoa.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/25/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils
import SAMKeychain
import MWFeedParser

// MARK: NSObject
extension NSObject {
    func copy<T>() -> T! {
        return copy() as? T
    }

    func dictionaryWithValuesForKeyPaths(keyPaths: [String]) -> [String: Any] {
        var info: [String: Any] = [:]
        for keyPath in keyPaths {
            if let value = value(forKeyPath: keyPath) {
                info[keyPath] = value
            }
        }
        return info
    }
}

// JSON Patch
extension Array where Element == [String:Any] {
    func add(with key: String, value: Any) -> [[String:Any]] {
        var result: [[String:Any]] = []
        for var item in self {
            item[key] = value
            result.append(item)
        }
        return result
    }
}

// MARK: - CollectionType
extension Collection {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

struct Ratio {
    static let horizontal = kScreenSize.width / SwiftUtils.DeviceType.iPhone6.size.width
    static let vertical = kScreenSize.height / SwiftUtils.DeviceType.iPhone6.size.height
}

public func * (lhs: UIEdgeInsets, rhs: CGFloat) -> UIEdgeInsets {
    let top = lhs.top * rhs
    let left = lhs.left * rhs
    let bottom = lhs.bottom * rhs
    let right = lhs.right * rhs
    return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
}

enum RegularExpressionPattern: String {
    case RFCStandarEmail = "^([a-z0-9\\+_\\-]+)(.[a-z0-9\\+_\\-]+)*@([a-z0-9\\-]+\\.)+[a-z]{2,6}$"
    case Password6To16Characters = "^[a-z0-9]{6,16}$"
}

// MARK: - NSBundle
extension Bundle {
    func hasNib(name: String) -> Bool {
        return path(forResource: name, ofType: "nib") != nil
    }
}

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

// MARK: - Double
extension Double {
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    // to radiant
    var degree: Double {
        return .pi * self / 180.0
    }

    func percent(max: Double) -> Double {
        return 100 * self / max
    }

    // to meter
    var kilometer: Double {
        return self * 1000
    }

    // to gram
    var kilogram: Double {
        return self * 1000
    }

    // to second
    var hour: Double {
        return self * 3600
    }

    // to second
    var minute: Double {
        return self * 60
    }
}

// MARK: - UICollectionView
extension UICollectionView {
    var flowLayout: UICollectionViewFlowLayout! {
        return collectionViewLayout as? UICollectionViewFlowLayout
    }
}

// MARK: - CABasicAnimation
extension CABasicAnimation {
    class func circle(fromValue: CGFloat, toValue: CGFloat) -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = 0.5
        anim.repeatCount = 0
        anim.autoreverses = false
        anim.fromValue = fromValue
        anim.toValue = toValue
        return anim
    }
}

let kDeviceUUIDKey = "DeviceUUID"

// MARK: - UIDevice
extension UIDevice {
    var UUIDString: String {
        if let uuid = identifierForVendor {
            return uuid.uuidString
        }

        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            fatal("This app has no bundle identifier?")
            return ""
        }

        if let uuid = SAMKeychain.password(forService: bundleIdentifier, account: kDeviceUUIDKey) {
            return uuid
        }

        let uuid = NSUUID().uuidString
        SAMKeychain.setPassword(uuid, forService: bundleIdentifier, account: kDeviceUUIDKey)
        return uuid
    }

    /// Get device platform name. Ex: iPhone8,2...
    
    func platformName() -> String {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        guard let info = NSString(bytes: &sysinfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue) as String? else {
            fatalError("Cannot get system info.")
        }
        return info
    }
}

// MARK: - UILabel
extension UILabel {
    var string: String {
        if let text = text {
            return text
        } else {
            return ""
        }
    }
}

// MARK: - UITextView
extension UITextView {
    var string: String {
        if let text = text {
            return text
        } else {
            return ""
        }
    }
}

// MARK: - UITextField
extension UITextField {
    var string: String {
        if let text = text {
            return text
        } else {
            return ""
        }
    }
}

// MARK: - UISearchBar
extension UISearchBar {
    var string: String {
        if let text = text {
            return text
        } else {
            return ""
        }
    }
}

// MARK: - UIButton
extension UIButton {
    func title(state: UIControlState) -> String {
        if let text = title(for: state) {
            return text
        } else {
            return ""
        }
    }

    func attributedTitle(state: UIControlState) -> NSAttributedString {
        if let text = attributedTitle(for: state) {
            return text
        } else {
            return NSAttributedString()
        }
    }
}

// MARK: - UIView
extension UIView {
    func addTapGesture(target: Any?, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tap)
    }
}

// MARK: - String
extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }

    func hourMinute() -> String {
        var comps = components(separatedBy: ":")
        comps.removeLast()
        return comps.joined(separator: ":")
    }

    func boundingRectWithWidth(width: CGFloat, font: UIFont) -> CGRect {
        let rect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return self.boundingRect(with: rect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    }

    /// Convert String to Halfwidth
    public var halfSize: String {
        let text: CFMutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(text, nil, kCFStringTransformFullwidthHalfwidth, false)
        return text as String
    }

    /// Convert String to Fullwidth
    public var fullSize: String {
        let text: CFMutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(text, nil, kCFStringTransformFullwidthHalfwidth, true)
        return text as String
    }

    public var decodeHTML: String? {
        guard let decoded = self.removingPercentEncoding else { return nil }
        return decoded.decodingHTMLEntities()
    }
}
