//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 11.10.2024.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }

    func viewDidLoad()
    func getCellsTitle(for items: Int) -> String?
    func didTapEditProfile()
    func didTapMyNft()
    func didTapSelectedNft()
    func didTapWebsite(url: String)
    func updateUserProfile(_ profile: Profile)
}

final class ProfilePresenter {

    weak var view: ProfileViewControllerProtocol?

    private let router: ProfileRouterProtocol
    private var profile: Profile?
    private(set) var cellsItems: [CategoryCell] = [
        .myNft,
        .selectedNft,
        .aboutDev
    ]

    init(view: ProfileViewControllerProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.router = router
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {}

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
    func updateUserProfile(_ profile: Profile) {}
}
