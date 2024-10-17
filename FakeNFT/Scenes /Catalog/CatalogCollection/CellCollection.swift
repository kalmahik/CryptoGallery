//
//  CallCollection.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 12.10.2024.
//

import UIKit

final class CellTableCollectionNFT: UITableViewCell, ReuseIdentifying {

    private lazy var coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .top
        imageView.image = UIImage(named: "CoverCollection") // TODO: - Remove after adding API
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var nameCollection: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ghkm 17" // TODO: - Remove after adding API
        label.font = .bold17
        label.textColor = .ypBlack
        return label
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configCell(_ cover: UIImage, _ name: String, _ quantity: Int) {
        coverImage.image = cover
        nameCollection.text = "\(name) (\(quantity))"
    }

    // MARK: - View Layout

    private func setupLayout() {
        selectionStyle = .none
        backgroundColor = .none

        contentView.heightAnchor.constraint(equalToConstant: 187).isActive = true
        contentView.addSubview(coverImage)
        contentView.addSubview(nameCollection)

        NSLayoutConstraint.activate([
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            coverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImage.heightAnchor.constraint(equalToConstant: 140),

            nameCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameCollection.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 4)
        ])
    }
}
