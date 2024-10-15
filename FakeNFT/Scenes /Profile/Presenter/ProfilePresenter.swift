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
    private var profile: Profile?

    // MARK: - Lifecycle
    init(view: ProfileViewControllerProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.router = router
    }
}

// MARK: - ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {
        updateUserProfile(mockProfile()) // TODO: - Mock data
    }

    func getCellsTitle(for items: Int) -> String? {
        return cellsItems[items].title
    }

    func didTapEditProfile() {
        router.navigateToEditProfile(mockProfile()) // TODO: - Mock data
    }

    func didTapMyNft() {}
    func didTapSelectedNft() {}

    func didTapWebsite(url: String) {
        if let profile {
            router.navigateToWebsite(websiteURL: profile.website)
        }
    }

    func updateUserProfile(_ profile: Profile?) {
        if let profile = profile {
            self.profile = profile
        }
        view?.updateProfileDetails(profile: mockProfile()) // TODO: - Mock data
    }

    func updateUserProfileImage() {
        view?.updateUserProfileImageView(profile: mockProfile(), mode: .view) // TODO: - Mock data
    }
}

// MARK: - Mock data
extension ProfilePresenter {
    
    private func mockProfile() -> Profile {
        var avatar = ""
        if let url = Bundle.main.url(forResource: "UserPic", withExtension: "png") { // TODO: - Mock data
            avatar = url.absoluteString
        } else {
            Logger.shared.info("No user picture")
        }

        let profile = profile ?? Profile(
            name: "Joaquin Phoenix",
            avatar: avatar,
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы.",
            website: "JoaquinPhoenix.com",
            nfts: ["NFT1", "NFT2"],
            likes: ["Like1", "Like2"],
            id: "1122"
        )
        return profile
    }
}
