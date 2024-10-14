//
//  UserProfileImageView.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 14.10.2024.
//

import UIKit
import Kingfisher

enum ProfileImageMode {
    case view
    case edit

    var placeholder: UIImage {
        switch self {
        case .view:
            return UIImage(systemName: "person.circle.fill") ?? UIImage()
        case .edit:
            return UIImage(systemName: "person.crop.circle.fill.badge.plus") ?? UIImage()
        }
    }
}

final class UserProfileImageView: UIView {
    // MARK: - Private Properties
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35 // TODO: - Change
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .ypGrayUniversal
        return imageView
    }()

    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationKey.profChangeImage.localized(), for: .normal)
        button.titleLabel?.font = .medium10
        button.layer.cornerRadius = 35 // TODO: - Change
        button.clipsToBounds = true
        button.backgroundColor = .black.withAlphaComponent(0.6)
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

    // MARK: - Public Methods
    func setUserImage(_ image: UIImage?, mode: ProfileImageMode) {
        self.mode = mode
        if let image = image {
            userImageView.image = image
            userImageView.tintColor = nil
        } else {
            updatePlaceholder()
        }
    }

    func addChangePhotoButtonTarget(_ target: Any?, action: Selector) {
        changePhotoButton.addTarget(target, action: action, for: .touchUpInside)
    }

    func updateUserProfileImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
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
                Logger.shared.error(error.errorDescription ?? error.localizedDescription)
                completion(nil)
            }
        }
    }

    // MARK: - Private Methods
    private func updatePlaceholder() {
        userImageView.image = mode.placeholder
        userImageView.tintColor = .ypGrayUniversal
    }

    private func setupUI() {
        [userImageView, changePhotoButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        changePhotoButton.constraintCenters(to: userImageView)

        NSLayoutConstraint.activate([
            userImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userImageView.topAnchor.constraint(equalTo: self.topAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 70),
            userImageView.heightAnchor.constraint(equalToConstant: 70),
            userImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            changePhotoButton.widthAnchor.constraint(equalToConstant: 70),
            changePhotoButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
