//
//  GradientView.swift
//  FinanceStockTracker
//
//  Created by Ерхан on 28.03.2024.
//
import UIKit

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    
    private func setupGradient() {
        self.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [
            UIColor.init(red: 0, green: 0.37, blue: 0.51, alpha: 1).cgColor,
            UIColor.init(red: 0, green: 0.37, blue: 0.35, alpha: 1).cgColor
        ]
    }
    
    
}
