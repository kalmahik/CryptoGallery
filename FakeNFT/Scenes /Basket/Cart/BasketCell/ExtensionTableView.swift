//
//  ExtensionTableView.swift
//  FakeNFT
//
//  Created by Вадим on 14.10.2024.
//

import UIKit

// MARK: - Setup

extension NFTTableViewCell {
    func setupUI() {
        [mainContentStackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),

            mainContentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainContentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainContentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainContentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            deleteButton.widthAnchor.constraint(equalToConstant: 44),
            deleteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
