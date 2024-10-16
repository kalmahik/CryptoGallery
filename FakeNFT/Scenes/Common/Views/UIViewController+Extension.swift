//
//  UIViewController+Extension.swift
//  FakeNFT
//
//  Created by kalmahik on 15.10.2024.
//

import UIKit

extension UIViewController {
    func wrapWithNavigationController() -> UINavigationController {
        UINavigationController(rootViewController: self)
    }
}
