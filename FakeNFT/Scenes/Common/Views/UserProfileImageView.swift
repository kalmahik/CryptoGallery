//
//  UserProfileImageView.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 18.10.2024.
//

import Kingfisher
import UIKit

enum ProfileImageMode {
    case view
    case edit

    var placeholder: UIImage {
        switch self {
        case .view:
            return UIImage(systemName: "person.circle.fill") ?? UIImage()
        case .edit:
            return UIImage(systemName: "plus.circle") ?? UIImage()
        }
    }
}

final class UserProfileImageView: UIView {

    // MARK: - Private Properties

    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35 // TODO: - Change
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .ypGrayUniversal
        return imageView
    }()

    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationKey.profChangeImage.localized(), for: .normal)
        button.titleLabel?.font = .medium10
        button.layer.cornerRadius = 35 // TODO: - Change
        button.clipsToBounds = true
        button.backgroundColor = .black.withAlphaComponent(0.2)
        button.tintColor = .white
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.isHidden = true
        return button
    }()

    private var mode: ProfileImageMode = .view {
        didSet {
            updatePlaceholder()
            changePhotoButton.isHidden = mode == .view
        }
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - Configure view

extension UserProfileImageView {

    // MARK: - Public Methods

    func setProfile(_ profile: Profile?, mode: ProfileImageMode) {
        self.mode = mode
        if let profile, let avatarURLString = profile.avatar, let avatarURL = URL(string: avatarURLString) {
            updateUserProfileImage(with: avatarURL) { [weak self] image in
                if image != nil {
                    self?.userImageView.tintColor = nil
                } else {
                    self?.updatePlaceholder()
                }
            }
        } else {
            updatePlaceholder()
        }
    }

    func addChangePhotoButtonTarget(_ target: Any?, action: Selector) {
        changePhotoButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

// MARK: - Private Methods

extension UserProfileImageView {
    private func updateUserProfileImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        let cache = ImageCache.default
        cache.removeImage(forKey: url.absoluteString)

        userImageView.kf.indicatorType = .activity
        userImageView.kf.setImage(
            with: url,
            placeholder: mode.placeholder,
            options: [.transition(.fade(0.2))]
        ) { result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure(let error):
                Logger.shared.error("Ошибка загрузки изображения: \(error.localizedDescription)")
                self.updatePlaceholder()
                completion(nil)
            }
        }
    }

    private func updatePlaceholder() {
        userImageView.image = mode.placeholder
        userImageView.tintColor = .ypGrayUniversal
    }
}

// MARK: - Layout

extension UserProfileImageView {
    private func setupUI() {
        [userImageView, changePhotoButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        changePhotoButton.constraintCenters(to: userImageView)
        userImageView.constraintCenters(to: self)

        NSLayoutConstraint.activate([
            userImageView.widthAnchor.constraint(equalToConstant: 70),
            userImageView.heightAnchor.constraint(equalToConstant: 70),

            changePhotoButton.widthAnchor.constraint(equalToConstant: 70),
            changePhotoButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
