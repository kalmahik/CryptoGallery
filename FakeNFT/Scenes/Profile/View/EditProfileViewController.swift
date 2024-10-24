//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 15.10.2024.
//

import UIKit

protocol EditProfileViewControllerProtocol: AnyObject {
    func updateSections()
    func reloadSection(_ section: Int)
    func dismissView()
}

enum SectionHeader: CaseIterable {
    case userPic
    case name
    case description
    case webSite

    var title: String? {
        switch self {
        case .userPic:
            return nil
        case .name:
            return LocalizationKey.profEditName.localized()
        case .description:
            return LocalizationKey.profEditDescription.localized()
        case .webSite:
            return LocalizationKey.profEditWebsite.localized()
        }
    }
}

final class EditProfileViewController: UIViewController {

    private let presenter: EditProfilePresenterProtocol

    // MARK: - Private Properties

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypWhite
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserPicCell.self)
        tableView.register(TextViewCell.self)
        return tableView
    }()

    // MARK: - Init

    init(presenter: EditProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeKeyboardObservers()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        setupKeyboardObservers()
        dismissKeyboard(view: view)
        presenter.viewDidLoad()
    }
}

// MARK: - Layout

extension EditProfileViewController {

    // MARK: - Private Methods

    private func setupUI() {
        [tableView, closeButton].forEach {
            view.setupView($0)
        }

        tableView.constraintEdges(to: view)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.Padding.large24),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Padding.large24)
        ])
    }
}

// MARK: - Keyboard Notification

extension EditProfileViewController {

    // MARK: - Private Methods

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    // MARK: - Keyboard Handling

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let bottomInset = keyboardHeight - view.safeAreaInsets.bottom
            tableView.contentInset.bottom = bottomInset
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset.bottom = 0
    }
}

// MARK: - Action

extension EditProfileViewController {
    @objc private func openImagePicker() {
        presenter.openImagePicker()
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height / 2

            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }

    @objc private func tapCloseButton() {
        presenter.tapCloseButton()
    }
}

// MARK: - UITableViewDelegate

extension EditProfileViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource

extension EditProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sections.isEmpty ? 0 : presenter.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section >= 0 && section < presenter.sections.count else {
            return 0
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section >= 0 && indexPath.section < presenter.sections.count else {
            return UITableViewCell()
        }

        if indexPath.section == 0 {
            let cell: UserPicCell = tableView.dequeueReusableCell()
            let updatedProfile = presenter.getUpdatedProfile()
            cell.setUserImage(updatedProfile)
            cell.delegate = self
            cell.addChangePhotoButtonTarget(self, action: #selector(openImagePicker))
            cell.selectionStyle = .none
            return cell
        } else {
            let cell: TextViewCell = tableView.dequeueReusableCell()
            cell.delegate = self
            cell.section = indexPath.section

            if let text = presenter.getTextForSection(indexPath.section) {
                cell.changeText(text)
            }
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section >= 0 && indexPath.section < presenter.sections.count else {
            return 0
        }
        return UITableView.automaticDimension
    }
}

// MARK: - Header

extension EditProfileViewController {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section >= 0 && section < presenter.sections.count else {
            return nil
        }
        return presenter.getSectionTitle(for: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section >= 0 && section < presenter.sections.count else {
            return nil
        }

        let sectionType = presenter.sections[section]

        switch sectionType {
        case .userPic, .name, .description, .webSite:
            if let headerTitle = sectionType.title {
                return TableViewHeaderAndFooterHelper.configureTextHeaderView(title: headerTitle)
            }
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section >= 0 && section < presenter.sections.count else {
            return 0
        }
        return UIConstants.Heights.height28
    }
}

// MARK: - Footer

extension EditProfileViewController {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section >= 0 && section < presenter.sections.count else {
            return nil
        }

        if presenter.shouldShowFooter(for: section) {
            return TableViewHeaderAndFooterHelper.configureFooterView()
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section >= 0 && section < presenter.sections.count else {
            return 0
        }
        return presenter.shouldShowFooter(for: section) ?
        UIConstants.Heights.height30 :
        UIConstants.Heights.height24
    }
}

// MARK: - EditProfileView

extension EditProfileViewController: EditProfileViewControllerProtocol {
    func updateSections() {
        tableView.reloadData()
    }

    func reloadSection(_ section: Int) {
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }

    func dismissView() {
        dismiss(animated: true)
    }
}

// MARK: - TextViewCellDelegate

extension EditProfileViewController: TextViewCellDelegate {
    func textViewCell(_ cell: TextViewCell, didUpdateText text: String, for section: Int) {
        presenter.updateProfileData(text: text, for: section)
    }
}

// MARK: - UserPicCellDelegate

extension EditProfileViewController: UserPicCellDelegate {
    func userPicCellDidTapChangePhotoButton(_ cell: UserPicCell) {
        let alertController = UIAlertController(title: LocalizationKey.alertTitle.localized(), message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "https://example.com/avatar.png"
        }
        let cancelAction = UIAlertAction(title: LocalizationKey.actionClose.localized(), style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: LocalizationKey.actionOK.localized(), style: .default) { [weak self] _ in
            guard let self, let urlText = alertController.textFields?.first?.text else { return }
            self.presenter.updateProfileData(text: urlText, for: 0)
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
}
