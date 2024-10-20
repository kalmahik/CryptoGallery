//
//  DeleteConfirmationViewController.swift
//  FakeNFT
//
//  Created by Вадим on 14.10.2024.
//

import UIKit

final class DeleteConfirmationViewController: UIViewController {

    // MARK: - Public Properties

    var nftImage: UIImage?
    var onDeleteConfirmed: (() -> Void)?

    // MARK: - Private Properties

    private let confirmationButtonTitle = LocalizationKey.basketAlert.localized()
    private let deleteButtonTitle = LocalizationKey.delete.localized()
    private let cancelButtonTitle = LocalizationKey.back.localized()

    private lazy var backgroundBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView(image: nftImage)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = UIConstants.CornerRadius.small12
        imageView.widthAnchor.constraint(equalToConstant: 108).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        return imageView
    }()

    private lazy var confirmationLabel: UILabel = {
        let label = UILabel()
        label.text = confirmationButtonTitle
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.font = .regular13
        label.numberOfLines = 0
        return label
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(deleteButtonTitle, for: .normal)
        button.setTitleColor(.ypRedUniversal, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = UIConstants.CornerRadius.small12
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(cancelButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = UIConstants.CornerRadius.small12
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nftImageView, confirmationLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deleteButton, cancelButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [contentStackView, buttonStackView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        return stackView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // MARK: - Actions

    @objc private func deleteTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onDeleteConfirmed?()
        }
    }

    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}

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
