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

    weak var view: ProfileViewControllerProtocol?
    var cellsItems: [CategoryCell] = [
        .myNft,
        .selectedNft,
        .aboutDev
    ]

    private let router: ProfileRouterProtocol
    private var profile: Profile?

    init(view: ProfileViewControllerProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.router = router
    }

    private func mockProfile() -> Profile {
        var avatar = ""
        if let url = Bundle.main.url(forResource: "UserPic", withExtension: "png") { // TODO: - Mock data
            avatar = url.absoluteString
        } else {
            Logger.shared.info("No user picture")
        }

        let mockProfile = Profile( // TODO: - Mock data
            name: "Joaquin Phoenix",
            avatar: "",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            website: "JoaquinPhoenix.com",
            nfts: ["One", "Two", "Three"],
            likes: ["One", "Two", "Three"],
            id: "1122")
        return mockProfile
    }
}

// MARK: - ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {
        updateUserProfile(profile)
    }

    func getCellsTitle(for items: Int) -> String? {
        return cellsItems[items].title
    }

    func didTapEditProfile() {
        router.navigateToEditProfile(profile)

    }

    func didTapMyNft() {}
    func didTapSelectedNft() {}

    func didTapWebsite(url: String) {
        if let profile {
            router.navigateToWebsite(websiteURL: profile.website)
        }
    }

    func updateUserProfile(_ profile: Profile?) {
        view?.updateProfileDetails(profile: mockProfile()) // TODO: - Mock data
    }

    func updateUserProfileImage() {
        view?.updateUserProfileImageView(profile: mockProfile(), mode: .view) // TODO: - Mock data
    }
}
