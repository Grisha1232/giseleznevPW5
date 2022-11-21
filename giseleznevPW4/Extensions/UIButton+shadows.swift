//
//  UIButton+shadows.swift
//
//  Created by Григорий Селезнев on 10/29/22.
//

import UIKit

extension UIButton {
    func applyShadows() {
        layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0
        layer.masksToBounds = false
    }
    
}

