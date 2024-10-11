//
//  ProfileRouter.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 11.10.2024.
//

import UIKit
import SafariServices

protocol ProfileRouterProtocol: AnyObject {
    func navigateToMyNFT()
    func navigateToSelectedNFT()
    func navigateToEditProfile(profile: Profile)
    func navigateToAboutTheDeveloper()
    func navigateToWebsite(websiteURL: String)
}

final class ProfileRouter {
    // MARK: - Properties
    weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension ProfileRouter: ProfileRouterProtocol {
    func navigateToMyNFT() {
    }

    func navigateToSelectedNFT() {
    }

    func navigateToEditProfile(profile: Profile) {
    }

    func navigateToAboutTheDeveloper() {
    }

    func navigateToWebsite(websiteURL: String) {
        guard let viewController, let websiteURL = URL(string: websiteURL) else { return }
        let websiteViewController = SFSafariViewController(url: websiteURL)
        websiteViewController.hidesBottomBarWhenPushed = true
        viewController.navigationController?.present(websiteViewController, animated: true)
    }
}
