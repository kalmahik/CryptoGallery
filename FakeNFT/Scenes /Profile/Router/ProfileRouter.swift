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
    func navigateToEditProfile(_ profile: Profile?)
    func navigateToAboutTheDeveloper()
    func navigateToWebsite(websiteURL: String)
}

final class ProfileRouter {
    // MARK: - Public Properties
    weak var viewController: UIViewController?

    // MARK: - Private Properties
    private let profileService: ProfileService

    // MARK: - Init
    init(viewController: UIViewController, profileService: ProfileService) {
        self.viewController = viewController
        self.profileService = profileService
    }
}

// MARK: - ProfileRouterProtocol
extension ProfileRouter: ProfileRouterProtocol {
    func navigateToMyNFT() {}

    func navigateToSelectedNFT() {}

    func navigateToEditProfile(_ profile: Profile?) {
        guard let viewController else { return }

        let editProfileViewController = EditProfileViewController()
        let presenter = EditProfilePresenter(
            view: editProfileViewController,
            profile: profile,
            profileService: profileService
        )
        editProfileViewController.presenter = presenter
        editProfileViewController.modalPresentationStyle = .formSheet

        DispatchQueue.main.async {
            viewController.present(editProfileViewController, animated: true)
        }
    }

    func navigateToAboutTheDeveloper() {}

    func navigateToWebsite(websiteURL: String) {
        var urlString = websiteURL
        if !websiteURL.lowercased().hasPrefix("http://") && !websiteURL.lowercased().hasPrefix("https://") {
            urlString = "https://\(websiteURL)"
        }

        guard let viewController = viewController, let url = URL(string: urlString), ["http", "https"].contains(url.scheme?.lowercased()) else {
            Logger.shared.error("Неверный или неподдерживаемый URL: \(urlString)")
            return
        }

        let websiteViewController = SFSafariViewController(url: url)
        websiteViewController.hidesBottomBarWhenPushed = true
        viewController.navigationController?.present(websiteViewController, animated: true)
    }
}