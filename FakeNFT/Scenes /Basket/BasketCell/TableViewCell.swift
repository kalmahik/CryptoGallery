//
//  TableViewCell.swift
//  FakeNFT
//
//  Created by Вадим on 12.10.2024.
//

import UIKit

final class NFTTableViewCell: UITableViewCell, NFTCellView {

    // MARK: - Public Properties

    lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let removeNftImage = UIImage(named: "removeNft")
        button.setImage(removeNftImage, for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var mainContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageAndContentStackView, deleteButton])
        stackView.axis = .horizontal
        stackView.spacing = 100
        stackView.alignment = .center
        return stackView
    }()

    // MARK: - Private Properties

    private let priceTitle = LocalizationKey.price.localized()
    private var presenter: NFTCellPresenter?

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bold17
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        return label
    }()

    private lazy var ratingView: UIRating = {
        let ratingView = UIRating(rating: 1)
        ratingView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        return ratingView
    }()

    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = priceTitle
        label.font = .regular13
        label.textColor = .ypBlack
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .bold17
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        return label
    }()

    private lazy var nameRatingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, ratingView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        return stackView
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceTitleLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameRatingStackView, priceStackView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        return stackView
    }()

    private lazy var imageAndContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nftImageView, contentStackView])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(with nft: NFT) {
        presenter = NFTCellPresenter(view: self, nft: nft)
        presenter?.loadNFTData()
    }

    func displayNFTName(_ name: String) {
        nameLabel.text = name
    }

    func displayNFTRating(_ rating: Int) {
        ratingView.removeFromSuperview()
        ratingView = UIRating(rating: rating)
        nameRatingStackView.addArrangedSubview(ratingView)
    }

    func displayNFTPrice(_ price: Double) {
        priceLabel.text = "\(price)"
    }

    func displayNFTImage(_ image: UIImage?) {
        nftImageView.image = image
    }

    // MARK: - Actions

    @objc private func deleteButtonTapped() {
        presenter?.deleteNFT()
    }
}
