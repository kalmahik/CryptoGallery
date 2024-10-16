//
//  UserPicCell.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 15.10.2024.
//

import UIKit

final class UserPicCell: UITableViewCell, ReuseIdentifying {

    // MARK: - Private Properties
    private lazy var userImageView: UserProfileImageView = {
        let imageView = UserProfileImageView(frame: .zero)
        return imageView
    }()

    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationKey.profChangeImage.localized(), for: .normal)
        button.titleLabel?.font = .medium10
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        button.backgroundColor = .black.withAlphaComponent(0.6)
        button.tintColor = .white
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        return button
    }()

    // MARK: - Initializers
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
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            userImageView.widthAnchor.constraint(equalToConstant: 70),
            userImageView.heightAnchor.constraint(equalToConstant: 70),
            userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            changePhotoButton.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor),
            changePhotoButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            changePhotoButton.widthAnchor.constraint(equalToConstant: 70),
            changePhotoButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
