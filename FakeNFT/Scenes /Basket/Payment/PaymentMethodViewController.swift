//
//  PaymentMethodViewController.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import UIKit

final class PaymentMethodViewController: UIViewController {

    // MARK: - Private Properties

    private let paymentTitleLabel = LocalizationKey.basketTitle.localized()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = paymentTitleLabel
        label.font = .bold17
        label.textColor = .ypBlack
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupNavigationBarTitle()
    }

    // MARK: - Private Methods

    private func setupNavigationBarTitle() {
        navigationItem.titleView = titleLabel
    }
}
