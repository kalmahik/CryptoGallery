//
//  NFTCell.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 22.10.2024.
//

import UIKit

final class NFTCell: UICollectionViewCell, ReuseIdentifying {

    // MARK: - Private Properties

    private var isLiked: Bool = false
    private var basketNFT: Bool = false

    // MARK: - UI Components

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: contentView.frame.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: contentView.frame.width).isActive = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = isLiked ? .ypRedUniversal : .ypWhiteUniversal
        return button
    }()

    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bold17
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium10
        return label
    }()

    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: basketNFT ? "removeNft" : "addNft"), for: .normal)
        button.tintColor = .ypBlack
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()

    private lazy var retingNFTStackView: UIRating = UIRating(rating: 0)

    private lazy var nftNameAndPriceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nftNameLabel, priceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private lazy var nftNamePriceAndBasketStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nftNameAndPriceStackView, basketButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var nftInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [retingNFTStackView, nftNamePriceAndBasketStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private lazy var nftStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, nftInfoStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .none
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    func configureCell(_ nft: NFT, _ isLiked: Bool) {
        retingNFTStackView.updateRating(nft.rating)
        nftNameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH"
        likeButton.tintColor = isLiked ? .ypRedUniversal : .ypWhiteUniversal
        let URLImage = URL(string: traitCollection.userInterfaceStyle == .dark ? nft.images[1] : nft.images[0])
        imageView.kf.setImage(with: URLImage)
    }
}

    // MARK: - Extension: View Layout

extension NFTCell {
    private func setupConstraints() {
        contentView.addSubview(nftStackView)
        imageView.addSubview(likeButton)

        NSLayoutConstraint.activate([
            nftStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
