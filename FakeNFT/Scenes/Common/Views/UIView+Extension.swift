//
//  UIView+Extension.swift
//  FakeNFT
//
//  Created by kalmahik on 11.10.2024.
//

import UIKit

extension UIView {
    func setupView(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
}

extension UIView {

    enum CornerRadiusType {
        case small10
        case small12
        case medium16
        case large35

        var value: CGFloat {
            switch self {
            case .small10:
                return UIConstants.CornerRadius.small10
            case .small12:
                return UIConstants.CornerRadius.small12
            case .medium16:
                return UIConstants.CornerRadius.medium16
            case .large35:
                return UIConstants.CornerRadius.large35
            }
        }
    }

    func applyCornerRadius(_ radiusType: CornerRadiusType) {
        self.layer.cornerRadius = radiusType.value
        self.clipsToBounds = true
    }

    func applyCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
