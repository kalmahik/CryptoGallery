//
//  CollectionViewCell.swift
//  FakeNFT
//
//  Created by Вадим on 18.10.2024.
//

import UIKit

final class CurrencyCell: UICollectionViewCell, CollectionViewProtokol {

    // MARK: - Private Properties

    private var presenter: CurrencyCellPresenterProtocol?

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .regular13
        label.textColor = .ypBlack
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return label
    }()

    private lazy var shortNameLabel: UILabel = {
        let label = UILabel()
        label.font = .regular13
        label.textColor = .ypGreenUniversal
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return label
    }()

    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fullNameLabel, shortNameLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoImageView, labelsStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()

    private lazy var cellButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypLightGrey
        button.layer.cornerRadius = UIConstants.CornerRadius.small12
        button.clipsToBounds = true
        button.addSubview(horizontalStackView)
        return button
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        presenter = CurrencyCellPresenter(view: self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(with currency: CurrencyType) {
        presenter?.configure(with: currency)
    }

    func displayLogo(_ image: UIImage?) {
        logoImageView.image = image
    }

    func displayFullName(_ name: String) {
        fullNameLabel.text = name
    }

    func displayShortName(_ name: String) {
        shortNameLabel.text = name
    }

    // MARK: - Private Methods

    private func setButtonAction(target: Any?, action: Selector) {
        cellButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

// MARK: - Setup

extension CurrencyCell {
    private func setupUI() {
        [cellButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [horizontalStackView].forEach {
            cellButton.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            horizontalStackView.leadingAnchor.constraint(equalTo: cellButton.leadingAnchor, constant: 12),
            horizontalStackView.trailingAnchor.constraint(equalTo: cellButton.trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: cellButton.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: cellButton.bottomAnchor)
        ])
    }
}