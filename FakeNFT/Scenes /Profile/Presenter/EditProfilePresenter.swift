//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 15.10.2024.
//

import Foundation

protocol EditProfileView: AnyObject {
    func updateSections()
    func reloadSection(_ section: Int)
    func dismissView()
}

final class EditProfilePresenter {
    // MARK: - Private Properties
    private var isImageChanged = false
    private weak var view: EditProfileView?
    private(set) var sections: [SectionHeader] = [
        .userPic,
        .name,
        .description,
        .webSite
    ]
    // MARK: - Initializers
    init(view: EditProfileView) {
        self.view = view
    }
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
