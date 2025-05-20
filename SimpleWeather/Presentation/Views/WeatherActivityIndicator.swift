//
//  WeatherActivityIndicator.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 20.05.2025.
//

import UIKit

final class WeatherStyleActivityIndicator: UIView {
    
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        startRotating()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
        startRotating()
    }
    
    private func setupLayers() {
        let radius = min(bounds.width, bounds.height) / 2 - 5
       
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )

        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 6
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineCap = .round

        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemTeal.cgColor,
            UIColor.systemMint.cgColor,
            UIColor.systemBlue.cgColor
        ]
       
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = bounds
        gradientLayer.mask = shapeLayer
        
        layer.addSublayer(gradientLayer)
    }

    private func startRotating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1.0
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        layer.add(rotation, forKey: "rotationAnimation")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
        let radius = min(bounds.width, bounds.height) / 2 - 5
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )
        
        shapeLayer.path = circularPath.cgPath
    }
}
