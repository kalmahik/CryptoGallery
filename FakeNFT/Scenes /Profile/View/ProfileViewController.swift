//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 11.10.2024.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {}

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

    private lazy var profileUserImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
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
        let stack = UIStackView(arrangedSubviews: [profileUserImage, nameLabel])
        stack.backgroundColor = .ypWhite
        stack.axis = .horizontal
        stack.spacing = 16
        return stack
    }()

    private lazy var globalStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                profileUserDataStack,
                descriptionLabel,
                websiteLabel,
                tableView
            ]
        )
        stack.backgroundColor = .ypWhite
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 20
        return stack
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsMultipleSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        view.addSubview(globalStack)
        globalStack.constraintEdges(to: view)
    }

    @objc
    private func tapEditButton() {}

    @objc
    private func tapToWebsite() {
        presenter?.didTapWebsite(url: websiteURL)
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryCell.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        return cell
    }
}

// MARK: - ProfileViewControllerProtocol
extension ProfileViewController: ProfileViewControllerProtocol {}
