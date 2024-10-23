//
//  ProfileCell.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 14.10.2024.
//

import UIKit

final class ProfileCell: UITableViewCell, ReuseIdentifying {

    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold17
        label.textColor = .ypBlack
        label.numberOfLines = 1
        return label
    }()

    private lazy var customDisclosureIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .ypBlack
        return imageView
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .background
        setupCell()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Cell

extension ProfileCell {

    // MARK: - Public Methods

    func configure(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - Layout

extension ProfileCell {

    // MARK: - Private Methods

    private func setupCell() {
        [titleLabel, customDisclosureIndicator].forEach {
            contentView.setupView($0)
        }
        titleLabel.constraintEdges(to: contentView)

        NSLayoutConstraint.activate([
            customDisclosureIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customDisclosureIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
