//
//  UILabel + Extension.swift
//  FinanceStockTracker
//
//  Created by Ерхан on 28.03.2024.
//

import UIKit

extension UILabel {
    
    convenience init(text: String = "", textColor: UIColor = .white, font: UIFont) {
        self.init()
        
        self.textColor = textColor
        self.text = text
        self.font = font
    }
    
}
