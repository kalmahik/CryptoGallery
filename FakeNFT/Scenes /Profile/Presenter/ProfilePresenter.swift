//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 11.10.2024.
//

import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    var cellsItems: [CategoryCell] { get }

    func viewDidLoad()
    func getCellsTitle(for items: Int) -> String?
    func didTapEditProfile()
    func didTapMyNft()
    func didTapSelectedNft()
    func didTapWebsite(url: String)
    func updateUserProfile(_ profile: Profile?)
    func updateUserProfileImage()
}

final class ProfilePresenter {
    // MARK: - Public Properties
    weak var view: ProfileViewControllerProtocol?
    var cellsItems: [CategoryCell] = [
        .myNft,
        .selectedNft,
        .aboutDev
    ]

    // MARK: - Private Properties
    private let router: ProfileRouterProtocol
    private let profileService: ProfileService
    private var profile: Profile?

    // MARK: - Lifecycle
    init(
        view: ProfileViewControllerProtocol,
        router: ProfileRouterProtocol,
        profileService: ProfileService
    ) {
        self.view = view
        self.router = router
        self.profileService = profileService
    }
}

// MARK: - ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {
        fetchUserProfile()
    }

    func getCellsTitle(for items: Int) -> String? {
        return cellsItems[items].title
    }

    func didTapEditProfile() {
        if let profile {
            router.navigateToEditProfile(profile)
        }
    }

    func didTapMyNft() {}
    func didTapSelectedNft() {}

    func didTapWebsite(url: String) {
        if let profile {
            router.navigateToWebsite(websiteURL: profile.website)
        }
    }

    func updateUserProfile(_ profile: Profile?) {
        if let profile {
            self.profile = profile
        }
        view?.updateProfileDetails(profile: profile)
    }

    func updateUserProfileImage() {
        if let profile {
            view?.updateUserProfileImageView(profile: profile, mode: .view)
        }
    }
}

// MARK: - Fetching Profile Data from Network
extension ProfilePresenter {
    private func fetchUserProfile() {
        profileService.getProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.updateUserProfile(profile)
            case .failure(let error):
                self.handleError(error)
                Logger.shared.error("Error fetching profile: \(error)")
            }
        }
    }
}

// MARK: - Show Error
extension ProfilePresenter {
    private func handleError(_ error: Error) {
        let errorMessage = "Не удалось загрузить профиль. Попробуйте снова." // TODO: - Change Localization

        let errorModel = ErrorModel(
            message: errorMessage,
            actionText: "Повторить", // TODO: - Change Localization
            action: { [weak self] in
                guard let self else { return }
                self.fetchUserProfile()
            }
        )

        if let view = self.view as? ErrorView {
            view.showError(errorModel)
        }
    }
}
