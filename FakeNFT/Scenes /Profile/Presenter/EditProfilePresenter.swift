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
    func updateProfileData(text: String, for section: Int)
    func shouldShowFooter(for section: Int) -> Bool
}

final class EditProfilePresenter {
    // MARK: - Public Properties
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
    private let profileService: ProfileService
    private var profileBuilder: ProfileBuilder

    // MARK: - Initializers
    init(
        view: EditProfileViewControllerProtocol,
        profile: Profile?,
        profileService: ProfileService
    ) {
        self.view = view
        self.profile = profile
        self.profileService = profileService
        if let profile = profile {
            self.profileBuilder = ProfileBuilder(profile: profile)
        } else {
            self.profileBuilder = ProfileBuilder(profile: Profile.emptyProfile())
        }
    }
}

// MARK: - EditProfilePresenterProtocol
extension EditProfilePresenter: EditProfilePresenterProtocol {
    // MARK: - Public Methods
    func viewDidLoad() {
        view?.updateSections()
    }

    func tapCloseButton() {
        saveProfileChanges()
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
        if let profile {
            switch sections[section] {
            case .userPic:
                return nil
            case .name:
                return profileBuilder.currentName
            case .description:
                return profileBuilder.currentDescription
            case .webSite:
                return profileBuilder.currentWebsite
            }
        }
        return nil
    }

    func updateProfileData(text: String, for section: Int) {
        switch sections[section] {
        case .name:
            profileBuilder = profileBuilder.setName(text)
        case .description:
            profileBuilder = profileBuilder.setDescription(text)
        case .webSite:
            profileBuilder = profileBuilder.setWebsite(text)
        default:
            break
        }
    }

    func shouldShowFooter(for section: Int) -> Bool {
        return section == 0 && isImageChanged
    }
}

// MARK: - Saving Profile Data to Network
extension EditProfilePresenter {
    private func saveProfileChanges() {
        guard let profile else { return }

        profileService.updateProfile(
            name: profile.name,
            avatar: profile.avatar,
            description: profile.description,
            website: profile.website,
            likes: profile.likes
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let updatedProfile):
                self.profile = updatedProfile
                self.view?.dismissView()
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
}

// MARK: - Show Error
extension EditProfilePresenter {
    private func handleError(_ error: Error) {
        let errorMessage = (error as? CustomError)?.localizedDescription ?? LocalizationKey.errorUnknown.localized()

        let errorModel = ErrorModel(
            message: errorMessage,
            actionText: LocalizationKey.errorRepeat.localized(),
            action: { [weak self] in
                guard let self = self else { return }
                self.saveProfileChanges()
            }
        )

        if let view = self.view as? ErrorView {
            view.showError(errorModel)
        }
    }
}