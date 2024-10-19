//
//  ProfileRouter.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 11.10.2024.
//

import SafariServices
import UIKit

protocol ProfileRouterProtocol: AnyObject {
    func navigateToMyNFT()
    func navigateToSelectedNFT()
    func navigateToEditProfile(_ profile: Profile?, delegate: EditProfilePresenterDelegate)
    func navigateToAboutTheDeveloper()
    func navigateToWebsite(websiteURL: String)
}

final class ProfileRouter {

    // MARK: - Public Properties

    weak var viewController: UIViewController?

    // MARK: - Private Properties

    private let profileService: ProfileService

    // MARK: - Init

    init(profileService: ProfileService) {
        self.profileService = profileService
    }
}

// MARK: - ProfileRouterProtocol

extension ProfileRouter: ProfileRouterProtocol {

    // MARK: - Public Methods

    func navigateToMyNFT() {}

    func navigateToSelectedNFT() {}

    func navigateToEditProfile(_ profile: Profile?, delegate: EditProfilePresenterDelegate) {
        guard let viewController else { return }

        let profileService = self.profileService
        let presenter = EditProfilePresenter(
            profile: profile,
            profileService: profileService
        )
        presenter.delegate = delegate

        let editProfileViewController = EditProfileViewController(presenter: presenter)
        presenter.view = editProfileViewController

        editProfileViewController.modalPresentationStyle = .formSheet

        DispatchQueue.main.async {
            viewController.present(editProfileViewController, animated: true)
        }
    }

    func navigateToAboutTheDeveloper() {
        let urlString = NetworkConstants.urlDev

        guard let viewController = viewController,
                let url = URL(string: urlString),
                ["http", "https"].contains(url.scheme?.lowercased()) else {
            Logger.shared.error("Неверный или неподдерживаемый URL: \(urlString)")
            return
        }

        let websiteViewController = SFSafariViewController(url: url)
        websiteViewController.hidesBottomBarWhenPushed = true
        viewController.navigationController?.present(websiteViewController, animated: true)
    }

    func navigateToWebsite(websiteURL: String) {
        var urlString = websiteURL
        if !websiteURL.lowercased().hasPrefix("http://") && !websiteURL.lowercased().hasPrefix("https://") {
            urlString = "https://\(websiteURL)"
        }

        guard let viewController = viewController,
                let url = URL(string: urlString),
                ["http", "https"].contains(url.scheme?.lowercased()) else {
            Logger.shared.error("Неверный или неподдерживаемый URL: \(urlString)")
            return
        }

        let websiteViewController = SFSafariViewController(url: url)
        websiteViewController.hidesBottomBarWhenPushed = true
        viewController.navigationController?.present(websiteViewController, animated: true)
    }
}
