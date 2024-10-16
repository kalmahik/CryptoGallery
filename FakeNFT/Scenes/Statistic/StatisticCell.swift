//
//  StatisticCell.swift
//  FakeNFT
//
//  Created by kalmahik on 11.10.2024.
//

import UIKit

final class StatisticCell: UITableViewCell, ReuseIdentifying {

    // MARK: - Private Properties
    
    private lazy var rootStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular15
        label.textColor = UIColor.textPrimary
        label.layer.borderWidth = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = 12
        stackView.layer.masksToBounds = true
        stackView.backgroundColor = .ypLightGrey
        return stackView
    }()
    
    private lazy var labelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var avatar: UIImageView = {
        let avatar = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        return avatar
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold22
        label.textColor = UIColor.textPrimary
        label.layer.borderWidth = 1
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold22
        label.textColor = UIColor.textPrimary
        label.layer.borderWidth = 1
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        return label
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public Methods

    func setupCell() {
        placeLabel.text = "1"
        nameLabel.text = "kjanerflkjabef jafhbalehflahebfkjahbsdkfh"
        scoreLabel.text = "45"
    }
}

extension StatisticCell {
    private func setupViews() {
        rootStack.addArrangedSubview(placeLabel)
        rootStack.addArrangedSubview(contentStack)
        contentStack.addArrangedSubview(avatar)
        contentStack.addArrangedSubview(labelStack)
        labelStack.addArrangedSubview(nameLabel)
        labelStack.addArrangedSubview(scoreLabel)
        setupView(rootStack)
    }

    private func setupConstraints() {
        rootStack.constraintEdges(to: self)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 80),
            placeLabel.widthAnchor.constraint(equalToConstant: 28),
            avatar.heightAnchor.constraint(equalToConstant: 28),
            avatar.widthAnchor.constraint(equalToConstant: 28)
        ])
    }
}
