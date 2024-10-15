//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 15.10.2024.
//

import Foundation

protocol EditProfilePresenterProtocol: AnyObject {
    var view: EditProfileViewControllerProtocol? { get set }
    var sections: [SectionHeader] { get }
    var profile: Profile? { get set }

    func viewDidLoad()
    func tapCloseButton()
    func getSectionTitle(for section: Int) -> String?
    func openImagePicker()
    func getTextForSection(_ section: Int) -> String?
    func shouldShowFooter(for section: Int) -> Bool
}

final class EditProfilePresenter {

    weak var view: EditProfileViewControllerProtocol?
    var profile: Profile?
    var sections: [SectionHeader] = [
        .userPic,
        .name,
        .description,
        .webSite
    ]

    // MARK: - Private Properties
    private var isImageChanged = false

    // MARK: - Initializers
    init(view: EditProfileViewControllerProtocol, profile: Profile?) {
        self.view = view
        self.profile = profile
    }
}

extension EditProfilePresenter: EditProfilePresenterProtocol {
    // MARK: - Public Methods
    func viewDidLoad() {
        view?.updateSections()
    }

    func tapCloseButton() {
        view?.dismissView()
    }

    func getSectionTitle(for section: Int) -> String? {
        return sections[section].title
    }

    func openImagePicker() {
        isImageChanged.toggle()
        view?.reloadSection(0)
    }

    func getTextForSection(_ section: Int) -> String? {
        switch sections[section] {
        case .userPic:
            return nil
        case .name:
            return "Joaquin Phoenix"
        case .description:
            return "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и ещё больше — на моём сайте. Открыт к коллаборациям."
        case .webSite:
            return "JoaquinPhoenix.com"
        }
    }

    func shouldShowFooter(for section: Int) -> Bool {
        return section == 0 && isImageChanged
    }
}
