//
//  UserPicCell.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 15.10.2024.
//

import UIKit

protocol UserPicCellDelegate: AnyObject {
    func userPicCellDidTapChangePhotoButton(_ cell: UserPicCell)
}

final class UserPicCell: UITableViewCell, ReuseIdentifying {

    // MARK: - Public Properties

    weak var delegate: UserPicCellDelegate?

    // MARK: - Private Properties

    private lazy var userImageView: UserProfileImageView = {
        let imageView = UserProfileImageView(frame: .zero)
        return imageView
    }()

    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationKey.profChangeImage.localized(), for: .normal)
        button.titleLabel?.font = .medium10
        button.layer.cornerRadius = UIConstants.CornerRadius.large35
        button.clipsToBounds = true
        button.backgroundColor = .black.withAlphaComponent(0.6)
        button.tintColor = .white
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(changePhotoButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .background
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure cell

extension UserPicCell {
    func setUserImage(_ profile: Profile?) {
        if let profile {
            userImageView.setProfile(profile, mode: .edit)
        }
    }

    func addChangePhotoButtonTarget(_ target: Any?, action: Selector) {
        changePhotoButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

// MARK: - Layout

extension UserPicCell {

    // MARK: - Private Methods

    private func setupUI() {
        [userImageView, changePhotoButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            userImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.Padding.large22),
            userImageView.widthAnchor.constraint(equalToConstant: UIConstants.Square.imageView),
            userImageView.heightAnchor.constraint(equalToConstant: UIConstants.Square.imageView),
            userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            changePhotoButton.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor),
            changePhotoButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            changePhotoButton.widthAnchor.constraint(equalToConstant: UIConstants.Square.imageView),
            changePhotoButton.heightAnchor.constraint(equalToConstant: UIConstants.Square.imageView)
        ])
    }
}

// MARK: - Action

extension UserPicCell {
    @objc private func changePhotoButtonTapped() {
        delegate?.userPicCellDidTapChangePhotoButton(self)
    }
}
