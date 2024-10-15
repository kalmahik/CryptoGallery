//
//  GlobalFunc.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 11.10.2024.
//

import UIKit

public func dismissKeyboard(view: UIView) {
    let tapGesture = UITapGestureRecognizer(
        target: view,
        action: #selector(UIView.endEditing(_:))
    )
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
}
