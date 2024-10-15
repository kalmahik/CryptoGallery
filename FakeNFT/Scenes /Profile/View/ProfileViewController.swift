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

    private var presenter: ProfilePresenterProtocol?
    private let servicesAssembly: ServicesAssembly
    private var websiteURL = ""
    private var myNftValueCount = 0
    private var selectedNftValueCount = 0
    private let cellIdentifier = "CategoryCell"

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
        let stack = UIStackView(arrangedSubviews: [userProfileImage, nameLabel])
        stack.backgroundColor = .ypWhite
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 16
        return stack
    }()

    private lazy var globalProfileStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                profileUserDataStack,
                descriptionLabel,
                websiteLabel,
                customSpacerView,
                tableView
            ]
        )
        stack.backgroundColor = .ypWhite
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        return stack
    }()

    private lazy var customSpacerView: UIView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: 20).isActive = true
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

    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)

        let router = ProfileRouter(viewController: self)
        presenter = ProfilePresenter(view: self, router: router)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter?.viewDidLoad()
        setupUI()
        setupNavigation()
    }
}

// MARK: - Layout
extension ProfileViewController {

    private func setupUI() {
        view.addSubview(globalProfileStack)
        [userProfileImage, globalProfileStack, profileUserDataStack, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            globalProfileStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            globalProfileStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            globalProfileStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            globalProfileStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            userProfileImage.widthAnchor.constraint(equalToConstant: 70),
            profileUserDataStack.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = editButton
    }
}

// MARK: - Actions
extension ProfileViewController {

    @objc
    private func tapEditButton() {
        presenter?.didTapEditProfile()
    }

    @objc
    private func tapToWebsite() {
        print("did tap website")
        presenter?.didTapWebsite(url: websiteURL)
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryCell.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileCell = tableView.dequeueReusableCell()
        guard let presenter, let title = presenter.cellsItems[indexPath.row].title else { return UITableViewCell() }
        ConfigureTableViewCellHelper.configureTableViewCell(
            cell,
            title: title,
            at: indexPath,
            myNFTValue: myNftValueCount,
            selectedNFTValue: selectedNftValueCount
        )
        return cell
    }
}

// MARK: - ProfileViewControllerProtocol
extension ProfileViewController: ProfileViewControllerProtocol {

    func updateProfileDetails(profile: Profile?) {
        if let profile {
            nameLabel.text = profile.name
            descriptionLabel.text = profile.description
            websiteLabel.text = profile.website
            myNftValueCount = profile.nfts.count
            selectedNftValueCount = profile.likes.count
            websiteURL = profile.website

            userProfileImage.setProfile(profile, mode: .edit)
            tableView.reloadData()
        } else {
            nameLabel.text = ""
            descriptionLabel.text = ""
            websiteLabel.text = ""
            userProfileImage.setProfile(nil, mode: .edit)
        }
    }

    func updateUserProfileImageView(profile: Profile?, mode: ProfileImageMode) {
        userProfileImage.setProfile(profile, mode: mode)
    }
}
