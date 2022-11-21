//
//  UIVIew+HapticResponse.swift
//
//  Created by Григорий Селезнев on 10/29/22.
//

import UIKit

extension UIView {
    func applyHapticResponse() {
        let impactMedium = UIImpactFeedbackGenerator(style: .medium)
        impactMedium.impactOccurred()
    }
}
