//
//  CircleProgressView.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/28/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import GLKit

@IBDesignable
class CircleProgressView: UIView {

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
    
    @IBInspectable var lineWidth: CGFloat = 5

    @IBInspectable var lineBackgroundColor: UIColor = .lightGray
    @IBInspectable var lineColor: UIColor = .orange

    @IBInspectable var isAnimation: Bool = false

    @IBInspectable var startDegree: Float = 0
    @IBInspectable var endDegree: Float = 360

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
    private let backgroundLayer: CAShapeLayer = CAShapeLayer()
    private let circleLayer: CAShapeLayer = CAShapeLayer()
    private var lineCapEnum: LineCap = .lineCapButt
    private var radius: CGFloat = 0
    private var centerPoint: CGPoint = .zero
    private var startAngle: CGFloat {
        return CGFloat(GLKMathDegreesToRadians(startDegree))
    }
    private var endAngle: CGFloat {
        return CGFloat(GLKMathDegreesToRadians(endDegree))
    }
    private var arcCenter: CGPoint {
        return CGPoint(x: radius, y: radius)
    }

    // MARK: - Cycle Life
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configValues(rect)
        drawBackground()
        drawCircleLine()
    }

    // MARK: - Private Functions
    private func configValues(_ rect: CGRect) {
        let minSize: CGFloat = min(rect.width, rect.height)
        radius = (minSize - lineWidth) / 2
        centerPoint = CGPoint(x: rect.width / 2 - radius, y: rect.height / 2 - radius)
    }

    private func drawBackground() {
        layer.removeAllSubLayers()
        layer.addSublayer(backgroundLayer)
        backgroundLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        backgroundLayer.position = centerPoint
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = lineBackgroundColor.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = lineCapEnum.value
        backgroundLayer.rasterizationScale = 2 * UIScreen.main.scale
        backgroundLayer.shouldRasterize = true
    }

    private func drawCircleLine() {
        layer.addSublayer(circleLayer)
        let circleEndAngle: CGFloat = startAngle + (value * (endAngle - startAngle)) / maxValue
        circleLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: circleEndAngle, clockwise: true).cgPath
        circleLayer.position = centerPoint
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = lineColor.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.lineCap = lineCapEnum.value
        circleLayer.rasterizationScale = 2 * UIScreen.main.scale
        circleLayer.shouldRasterize = true
    }

    private func drawCircleAnimation(with duration: CFTimeInterval) {
        circleLayer.removeAllAnimations()
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = duration
        drawAnimation.repeatCount = 1.0
        drawAnimation.fromValue = 0
        drawAnimation.toValue = 1
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        circleLayer.add(drawAnimation, forKey: "drawCircleAnimation")
        let colorsAnimation = CAKeyframeAnimation(keyPath: "strokeColor")
        if let color = circleLayer.strokeColor {
            colorsAnimation.values = [color]
        }
        colorsAnimation.calculationMode = kCAAnimationPaced
        colorsAnimation.isRemovedOnCompletion = false
        colorsAnimation.fillMode = kCAFillModeForwards
        colorsAnimation.duration = duration
        circleLayer.add(colorsAnimation, forKey: "strokeColor")
    }

    // MARK: - Public Functions
    func setValue(_ value: CGFloat, duration: CFTimeInterval = 1) {
        if value > maxValue {
            self.value = maxValue
        } else {
            self.value = value
        }
        if isAnimation {
            drawCircleAnimation(with: duration)
        }
        setNeedsDisplay()
        setNeedsLayout()
    }
}

// MARK: - CALayer Extension
extension CALayer {
    func removeAllSubLayers() {
        guard let sublayers = self.sublayers else { return }
        for layer in sublayers {
            layer.removeFromSuperlayer()
        }
    }
}
