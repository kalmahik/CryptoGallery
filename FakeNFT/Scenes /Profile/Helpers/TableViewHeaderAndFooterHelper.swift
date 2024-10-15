//
//  TableViewHeaderAndFooterHelper.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 15.10.2024.
//

import UIKit

final class TableViewHeaderAndFooterHelper {
    // MARK: - Public Methods
    static func configureTextHeaderView(
        title: String
    ) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .clear

        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont.boldSystemFont(ofSize: 22)
        headerLabel.text = title

        headerView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])

        return headerView
    }

    static func configureFooterView() -> UIView {
        let footerView = UIView()
        footerView.backgroundColor = .clear

        let footerLabel = UILabel()
        footerLabel.text = LocalizationKey.profDownloadImage.localized()
        footerLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        footerLabel.textAlignment = .center
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(footerLabel)

        NSLayoutConstraint.activate([
            footerLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            footerLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 6),
            footerLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor)
        ])
        return footerView
    }
}

