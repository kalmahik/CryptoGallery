//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 11.10.2024.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    func updateProfileDetails(profile: Profile?)
    func updateUserProfileImageView(profile: Profile?, mode: ProfileImageMode)
}

enum CategoryCell: CaseIterable {
    case myNft
    case selectedNft
    case aboutDev

    var title: String? {
        switch self {
        case .myNft:
            return LocalizationKey.profMyNft.localized()
        case .selectedNft:
            return LocalizationKey.profSelectedNft.localized()
        case .aboutDev:
            return LocalizationKey.profAboutDev.localized()
        }
    }
}

final class ProfileViewController: UIViewController {

    // MARK: - Public Properties

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Private Properties

    private let presenter: ProfilePresenterProtocol

    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(tapEditButton)
        )
        button.tintColor = .ypBlack
        return button
    }()

    private lazy var shimmerUserProfileImage: ShimmerView = {
        let shimmerView = ShimmerView()
        shimmerView.layer.cornerRadius = UIConstants.CornerRadius.large35
        shimmerView.clipsToBounds = true
        return shimmerView
    }()

    private lazy var shimmerNameLabel: ShimmerView = {
        let shimmerView = ShimmerView()
        shimmerView.layer.cornerRadius = UIConstants.CornerRadius.medium16
        shimmerView.clipsToBounds = true
        return shimmerView
    }()

    private lazy var shimmerDescriptionLabel: ShimmerView = {
        let shimmerView = ShimmerView()
        shimmerView.layer.cornerRadius = UIConstants.CornerRadius.medium16
        shimmerView.clipsToBounds = true
        return shimmerView
    }()

    private lazy var shimmerWebsiteLabel = {
        let shimmerView = ShimmerView()
        shimmerView.layer.cornerRadius = UIConstants.CornerRadius.small10
        shimmerView.clipsToBounds = true
        return shimmerView
    }()

    private lazy var userProfileImage: UserProfileImageView = {
        let imageView = UserProfileImageView(frame: .zero)
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bold22
        label.textColor = .ypBlack
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular13
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .ypBlack
        return label
    }()

    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.font = .regular15
        label.textColor = .ypBlueUniversal
        let action = UITapGestureRecognizer(
            target: self,
            action: #selector(tapToWebsite)
        )
        label.addGestureRecognizer(action)
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var profileUserDataStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            userProfileImage,
            nameLabel,
            shimmerUserProfileImage,
            shimmerNameLabel
        ])
        stack.backgroundColor = .ypWhite
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = UIConstants.Spacing.medium16
        return stack
    }()

    private lazy var globalProfileStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                profileUserDataStack,
                descriptionLabel,
                shimmerDescriptionLabel,
                websiteLabel,
                shimmerWebsiteLabel,
                customSpacerView,
                tableView
            ]
        )
        stack.backgroundColor = .ypWhite
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = UIConstants.Spacing.large20
        return stack
    }()

    private lazy var customSpacerView: UIView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: UIConstants.Padding.large20).isActive = true
        return spacer
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsMultipleSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    // MARK: - Init

    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupUI()
        setupNavigation()
        showShimmerViews()
        showLoading()
        presenter.viewDidLoad()
    }
}

// MARK: - Layout

extension ProfileViewController {

    private func setupUI() {
        [globalProfileStack, activityIndicator].forEach {
            view.addSubview($0)
        }

        [userProfileImage,
         shimmerUserProfileImage,
         shimmerNameLabel,
         shimmerDescriptionLabel,
         globalProfileStack,
         profileUserDataStack,
         tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        shimmerUserProfileImage.constraintCenters(to: userProfileImage)
        activityIndicator.constraintCenters(to: view)

        NSLayoutConstraint.activate([
            globalProfileStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.Padding.large20),
            globalProfileStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.Padding.medium16),
            globalProfileStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIConstants.Padding.medium16),
            globalProfileStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            userProfileImage.widthAnchor.constraint(equalToConstant: UIConstants.Square.imageView),
            userProfileImage.heightAnchor.constraint(equalToConstant: UIConstants.Square.imageView),

            shimmerUserProfileImage.widthAnchor.constraint(equalTo: userProfileImage.widthAnchor),
            shimmerUserProfileImage.heightAnchor.constraint(equalTo: userProfileImage.heightAnchor),

            profileUserDataStack.heightAnchor.constraint(equalToConstant: UIConstants.Square.imageView),

            shimmerNameLabel.heightAnchor.constraint(equalToConstant: UIConstants.Heights.shimmerMedium),
            shimmerDescriptionLabel.heightAnchor.constraint(equalToConstant: UIConstants.Heights.shimmerLarge),
            shimmerWebsiteLabel.heightAnchor.constraint(equalToConstant: UIConstants.Heights.shimmerMedium)
        ])
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = editButton
    }
}

// MARK: - Shimmer

extension ProfileViewController {
    private func showShimmerViews() {
        [shimmerUserProfileImage, shimmerNameLabel, shimmerDescriptionLabel, shimmerWebsiteLabel].forEach {
            $0.isHidden = false
            $0.startShimmer()
        }

        [userProfileImage, nameLabel, descriptionLabel, websiteLabel].forEach {
            $0.isHidden = true
        }
    }

    private func hideShimmerViews() {
        [shimmerUserProfileImage, shimmerNameLabel, shimmerDescriptionLabel, shimmerWebsiteLabel].forEach {
            $0.isHidden = true
            $0.stopShimmer()
        }

        [userProfileImage, nameLabel, descriptionLabel, websiteLabel].forEach {
            $0.isHidden = false
        }
    }
}

// MARK: - Actions

extension ProfileViewController {

    @objc
    private func tapEditButton() {
        presenter.didTapEditProfile()
    }

    @objc
    private func tapToWebsite() {
        presenter.didTapWebsite()
    }
}

// MARK: - LoadingView

extension ProfileViewController: LoadingView {}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.Heights.rowHeightLarge54
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryCell.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileCell = tableView.dequeueReusableCell()
        guard let title = presenter.cellsItems[indexPath.row].title else { return UITableViewCell() }
        ConfigureTableViewCellHelper.configureTableViewCell(
            cell,
            title: title,
            at: indexPath,
            myNFTValue: presenter.myNftValueCount,
            selectedNFTValue: presenter.selectedNftValueCount
        )
        return cell
    }
}

// MARK: - ProfileViewControllerProtocol

extension ProfileViewController: ProfileViewControllerProtocol {

    func updateProfileDetails(profile: Profile?) {
        hideLoading()
        hideShimmerViews()

        if let profile {
            nameLabel.text = profile.name
            descriptionLabel.text = profile.description
            websiteLabel.text = profile.website
            userProfileImage.setProfile(profile, mode: .view)
            tableView.reloadData()
        }
    }

    func updateUserProfileImageView(profile: Profile?, mode: ProfileImageMode) {
        userProfileImage.setProfile(profile, mode: mode)
    }
}
