//
//  NFTHeader.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 22.10.2024.
//

import UIKit

final class NFTHeader: UICollectionReusableView, ReuseIdentifying {

    private var coverCollection = "mokCover"
    private var nameCollection = "Peach"
    private var authorCollection = "Gin Milin"
    private var introCollection = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."

    // MARK: - UI Components

    private lazy var coverCollectionImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: coverCollection)
        imageView.image = image
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameCollectionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.text = nameCollection
        label.font = .bold22
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var authorHeaderCollectionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        let textLocalizationClouse = LocalizationKey.catAuthor.localized()
        label.text = textLocalizationClouse + ":"
        label.font = .regular13
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var authorCollectionButton: UIButton = {
        let button = UIButton()
        button.setTitle(authorCollection, for: .normal)
        button.setTitleColor(.ypBlueUniversal, for: .normal)
        button.titleLabel?.font = .regular15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var introCollectionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular13
        label.text = introCollection
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .background
        return label
    }()

    private lazy var authorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorHeaderCollectionLabel, authorCollectionButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configureHeader(_ cover: String, _ title: String, _ author: String, _ intro: String) {

    }

    func calculateHeight(for width: CGFloat) -> CGFloat {
        let size = CGSize(width: width - 32, height: CGFloat.greatestFiniteMagnitude)
        let estimatedSize =
        coverCollectionImageView.sizeThatFits(size).height +
        nameCollectionLabel.sizeThatFits(size).height +
        authorCollectionButton.sizeThatFits(size).height +
        introCollectionLabel.sizeThatFits(size).height + 8 + 16 + 24
        return estimatedSize
    }
}

// MARK: - Extension: View Layout

extension NFTHeader {
    private func setupConstraints() {
        addSubview(coverCollectionImageView)
        addSubview(nameCollectionLabel)
        addSubview(authorStackView)
        addSubview(introCollectionLabel)

        NSLayoutConstraint.activate([
            coverCollectionImageView.topAnchor.constraint(equalTo: topAnchor),
            coverCollectionImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverCollectionImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            nameCollectionLabel.topAnchor.constraint(equalTo: coverCollectionImageView.bottomAnchor, constant: 16),
            nameCollectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameCollectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            authorStackView.topAnchor.constraint(equalTo: nameCollectionLabel.bottomAnchor, constant: 8),
            authorStackView.leadingAnchor.constraint(equalTo: nameCollectionLabel.leadingAnchor),
            authorStackView.trailingAnchor.constraint(lessThanOrEqualTo: nameCollectionLabel.trailingAnchor),

            introCollectionLabel.topAnchor.constraint(equalTo: authorStackView.bottomAnchor),
            introCollectionLabel.leadingAnchor.constraint(equalTo: nameCollectionLabel.leadingAnchor),
            introCollectionLabel.trailingAnchor.constraint(equalTo: nameCollectionLabel.trailingAnchor),
            introCollectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
}
