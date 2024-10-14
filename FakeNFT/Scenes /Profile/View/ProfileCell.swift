//
//  ProfileCell.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 14.10.2024.
//

import UIKit

final class ProfileCell: UITableViewCell, ReuseIdentifying {

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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        contentView.addSubview(titleLabel)
        [titleLabel, customDisclosureIndicator].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        titleLabel.constraintEdges(to: contentView)

        NSLayoutConstraint.activate([
            customDisclosureIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customDisclosureIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with title: String) {
        titleLabel.text = title
    }
}
