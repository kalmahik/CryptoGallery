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
    func updateUserProfileImage(url: URL)
}

final class ProfilePresenter {

    let mockProfile = Profile( // TODO: - Mock data
        name: "Joaquin Phoenix",
        avatar: "",
        description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
        website: "Joaquin Phoenix.com",
        nfts: ["One", "Two", "Three"],
        likes: ["One", "Two", "Three"],
        id: "1122")

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
}

// MARK: - ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {
        updateUserProfile(profile)

        if let url = Bundle.main.url(forResource: "UserPic", withExtension: "png") { // TODO: - Mock data
            updateUserProfileImage(url: url)
        } else {
            print("no pic")
        }
    }

    func getCellsTitle(for items: Int) -> String? {
        return cellsItems[items].title
    }

    func didTapEditProfile() {
        if let profile {
            router.navigateToEditProfile(profile: profile)
        }
    }

    func didTapMyNft() {}
    func didTapSelectedNft() {}
    func didTapWebsite(url: String) {}
    func updateUserProfile(_ profile: Profile?) {
        view?.updateProfileDetails(profile: mockProfile) // TODO: - Mock data
    }

    func updateUserProfileImage(url: URL) {
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(systemName: "person.crop.circle.fill"),
                              options: [.transition(.fade(0.2))]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                self.view?.updateUserProfile(image: value.image)
            case .failure(let error):
                Logger.shared.error(error.errorDescription ?? error.localizedDescription)
            }
        }
    }
}
