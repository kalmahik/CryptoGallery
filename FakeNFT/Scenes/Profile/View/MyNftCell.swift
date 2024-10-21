//
//  MyNftCell.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 21.10.2024.
//

import UIKit

final class MyNftCell: UITableViewCell, ReuseIdentifying {

    // MARK: - Private Properties

    private var id: String?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold17
        return label
    }()

    private lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationKey.profFromAuthor.localized()
        label.font = UIFont.regular15
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular13
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        // TODO: Change color and font
        label.font = UIFont.regular13
        label.text = LocalizationKey.price.localized()
        return label
    }()

    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        // TODO: Change color and font
        label.font = UIFont.bold17
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private lazy var coinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold17
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = UIConstants.CornerRadius.small12
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var ratingView = UIRating(rating: 0)

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.accessibilityIdentifier = "likeButton"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypLightGrey
        let heartImage = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
        button.setImage(heartImage, for: .normal)
        button.addTarget(self, action: #selector(tapFavoriteButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Stack Views

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, ratingView, authorStackView])
        stackView.axis = .vertical
        stackView.spacing = UIConstants.Spacing.small4
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: UIConstants.Insets.large23,
            left: UIConstants.Insets.zero,
            bottom: UIConstants.Insets.large23,
            right: UIConstants.Insets.zero
        )
        return stackView
    }()

    private lazy var priceValueStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceValueLabel, coinLabel])
        stackView.axis = .horizontal
        stackView.spacing = UIConstants.Spacing.small4
        return stackView
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, priceValueStackView])
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: UIConstants.Insets.large33,
            left: UIConstants.Insets.zero,
            bottom: UIConstants.Insets.large33,
            right: UIConstants.Insets.zero
        )
        stackView.axis = .vertical
        stackView.spacing = UIConstants.Spacing.small2
        return stackView
    }()

    private lazy var authorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fromLabel, authorLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = UIConstants.Spacing.small4
        fromLabel.setContentHuggingPriority(.required, for: .horizontal)
        authorLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nftImageView, textStackView, priceStackView])
        stackView.axis = .horizontal
        stackView.spacing = UIConstants.Spacing.large20
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: UIConstants.Insets.small8,
            left: UIConstants.Insets.medium16,
            bottom: UIConstants.Insets.small8,
            right: UIConstants.Insets.large39)
        return stackView
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .none
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension MyNftCell {
    private func setupUI() {
        [contentStackView, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.addSubview(contentStackView)
        nftImageView.addSubview(favoriteButton)

        contentStackView.constraintEdges(to: contentView)

        NSLayoutConstraint.activate([
            nftImageView.widthAnchor.constraint(equalToConstant: UIConstants.Heights.height108),
            nftImageView.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height108),

            favoriteButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: UIConstants.Heights.height40),
            favoriteButton.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height40)
        ])
    }
}

// MARK: - Configure Cell

extension MyNftCell {
    func configure(with nft: NFT) {
        titleLabel.text = nft.name
        ratingView.updateRating(nft.rating)
        priceValueLabel.text = String(format: "%.2f", nft.price)
        authorLabel.text = nft.author
        nftImageView.image = UIImage(named: nft.images.first ?? "placeholder") // TODO: - Change placeholder
    }
}

// MARK: - Action

extension MyNftCell {
    @objc
    private func tapFavoriteButton() {
        print("Add favorite")
    }
}
