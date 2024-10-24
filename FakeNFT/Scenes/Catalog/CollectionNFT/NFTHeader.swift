//
//  NFTHeader.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 22.10.2024.
//

import UIKit

final class NFTHeader: UICollectionReusableView, ReuseIdentifying {

    // MARK: - Private Properties

    private let heightCover: CGFloat = 310

    // MARK: - UI Components

    private lazy var coverCollectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return imageView
    }()

    private lazy var nameCollectionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
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
        button.setTitleColor(.ypBlueUniversal, for: .normal)
        button.titleLabel?.font = .regular15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var introCollectionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular13
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

    func configureHeader(_ collection: Collection) {
        nameCollectionLabel.text = collection.name
        authorCollectionButton.setTitle(collection.author, for: .normal)
        introCollectionLabel.text = collection.description
        
        let URLImage = URL(string: collection.cover)
        coverCollectionImageView.kf.setImage(with: URLImage)
    }

    func calculateHeight(for width: CGFloat) -> CGFloat {
        let size = CGSize(width: width - 32, height: CGFloat.greatestFiniteMagnitude)
        let estimatedSize =
        heightCover +
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
            coverCollectionImageView.heightAnchor.constraint(equalToConstant: heightCover),

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
