//
//  UIButton+Extension.swift
//  FakeNFT
//
//  Created by kalmahik on 24.10.2024.
//

import UIKit

extension UIButton {
    func toBarButtonItem() -> UIBarButtonItem? {
        UIBarButtonItem(customView: self)
    }
}
