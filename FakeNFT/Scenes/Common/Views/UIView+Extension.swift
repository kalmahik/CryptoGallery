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
        subview.layer.borderWidth = 1
        addSubview(subview)
    }
}
