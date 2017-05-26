//
//  ProgressBarView.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/22/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import SwiftUtils

@IBDesignable
class ProgressBarView: UIView {
    fileprivate enum LineCap: Int {
        case lineCapButt
        case lineCapRound
        case lineCapSquare

        var value: String {
            switch self {
            case .lineCapButt:
                return kCALineCapButt
            case .lineCapRound:
                return kCALineCapRound
            case .lineCapSquare:
                return kCALineCapSquare
            }
        }
    }

    // MARK: - Properties
    @IBInspectable var value: CGFloat = 0
    @IBInspectable var maxValue: CGFloat = 100

    @IBInspectable var lineWidth: CGFloat = 1

    @IBInspectable var lineBackgroundColor: UIColor = .lightGray
    @IBInspectable var lineColor: UIColor = .orange

    @IBInspectable var isAnimation: Bool = false

    @IBInspectable var lineCap: Int {
        get {
            return self.lineCapEnum.rawValue
        }
        set(shapeIndex) {
            self.lineCapEnum = .lineCapRound
            if let lineCap = LineCap(rawValue: shapeIndex) {
                self.lineCapEnum = lineCap
            }
        }
    }
    private let lineLayer: CAShapeLayer = CAShapeLayer()
    private var lineCapEnum: LineCap = .lineCapButt

    // MARK: - Cycle Life
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawBackground(rect)
        drawCircleLine(rect)
    }

    // MARK: - Public Functions
    func setValue(_ value: CGFloat, duration: CFTimeInterval = 1) {
        if value > maxValue {
            self.value = maxValue
        } else {
            self.value = value
        }
        if isAnimation {
            drawAnimation(with: duration)
        }
        setNeedsDisplay()
        setNeedsLayout()
    }

    // MARK: - Private Functions
    private func drawBackground(_ rect: CGRect) {
        layer.removeAllSubLayers()

        let path = UIBezierPath()
        let startPoint = rect.origin + CGPoint(x: 0, y: rect.height / 2)
        path.move(to: startPoint)
        path.addLine(to: startPoint + CGPoint(x: rect.width, y: 0))

        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = path.cgPath
        backgroundLayer.strokeColor = lineBackgroundColor.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = lineCapEnum.value
        layer.addSublayer(backgroundLayer)
    }

    private func drawCircleLine(_ rect: CGRect) {
        let percen = value / maxValue

        let path = UIBezierPath()
        let startPoint = rect.origin + CGPoint(x: 0, y: rect.height / 2)
        path.move(to: startPoint)
        path.addLine(to: startPoint + CGPoint(x: rect.width * percen, y: 0))

        lineLayer.path = path.cgPath
        lineLayer.strokeColor = lineColor.cgColor
        lineLayer.lineWidth = lineWidth
        lineLayer.lineCap = lineCapEnum.value
        layer.addSublayer(lineLayer)
    }

    private func drawAnimation(with duration: CFTimeInterval) {
        lineLayer.removeAllAnimations()
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = duration
        drawAnimation.repeatCount = 1.0
        drawAnimation.fromValue = 0
        drawAnimation.toValue = 1
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        lineLayer.add(drawAnimation, forKey: "drawAnimation")
    }
}
