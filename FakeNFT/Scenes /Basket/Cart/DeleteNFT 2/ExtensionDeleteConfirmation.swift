//
//  ExtensionDeleteConfirmation.swift
//  FakeNFT
//
//  Created by Вадим on 14.10.2024.
//

import UIKit

// MARK: - Setup

extension DeleteConfirmationViewController {
    func setupUI() {
        [backgroundBlurView, mainStackView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundBlurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundBlurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundBlurView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundBlurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 244),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),

            buttonStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// MARK: - UIView

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
