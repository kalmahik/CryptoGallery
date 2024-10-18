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
    private let payButtonTitle = LocalizationKey.basketForPayButton.localized()
    private let descriptionTitleLabel = LocalizationKey.basketAgreeDescription.localized()
    private let userTitleLabel = LocalizationKey.basketUserAgree.localized()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = paymentTitleLabel
        label.font = .bold17
        label.textColor = .ypBlack
        return label
    }()

    private lazy var customView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.layer.cornerRadius = UIConstants.CornerRadius.medium16
        view.heightAnchor.constraint(equalToConstant: 186).isActive = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    private lazy var agreeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = descriptionTitleLabel
        label.font = .regular13
        label.textColor = .ypBlack
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return label
    }()

    private lazy var agreeUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(userTitleLabel, for: .normal)
        button.titleLabel?.font = .regular13
        button.setTitleColor(.ypBlueUniversal, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(agreeUserButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [agreeDescriptionLabel, agreeUserButton])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(payButtonTitle, for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .bold17
        button.layer.cornerRadius = UIConstants.CornerRadius.medium16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupNavigationBarTitle()
        setupUI()
        setupConstraints()
    }

    // MARK: - Actions

    @objc private func agreeUserButtonTapped() {
        print("Вы согласились")
    }

    @objc func payButtonTapped() {
        print("Вы оплатили")
    }
}

// MARK: - Setup

extension PaymentMethodViewController {
    func setupUI() {
        [customView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [stackView, payButton].forEach {
            customView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -16),

            payButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            payButton.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -50)
        ])
    }

    private func setupNavigationBarTitle() {
        navigationItem.titleView = titleLabel
    }
}
