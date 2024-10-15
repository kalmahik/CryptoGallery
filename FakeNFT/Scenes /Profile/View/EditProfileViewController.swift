//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 15.10.2024.
//

import UIKit

protocol EditProfileViewControllerProtocol: AnyObject {
    var presenter: EditProfilePresenterProtocol? { get set }
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
    // MARK: - Private Properties
    var presenter: EditProfilePresenterProtocol?

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.tintColor = .ypBlack
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

    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeKeyboardNotification()
    }

    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        setupKeyboardNotification()
        dismissKeyboard(view: view)
        presenter?.viewDidLoad()
    }

    // MARK: - Private Methods
    private func setupUI() {
        [tableView, closeButton].forEach {
            view.addSubview($0)
        }

        tableView.constraintEdges(to: view)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }

    private func removeKeyboardNotification() {
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

    @objc private func openImagePicker() {
        presenter?.openImagePicker()
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
        presenter?.tapCloseButton()
    }
}

// MARK: - UITableViewDelegate
extension EditProfileViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension EditProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let presenter = presenter else {
            return 0
        }
        return presenter.sections.isEmpty ? 0 : presenter.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter, section >= 0 && section < presenter.sections.count else {
            return 0
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = presenter, indexPath.section >= 0 && indexPath.section < presenter.sections.count else {
            return UITableViewCell()
        }

        if indexPath.section == 0 {
            let cell: UserPicCell = tableView.dequeueReusableCell()
            cell.setUserImage(presenter.profile)
            cell.addChangePhotoButtonTarget(self, action: #selector(openImagePicker))
            cell.selectionStyle = .none
            return cell
        } else {
            let cell: TextViewCell = tableView.dequeueReusableCell()

            if let text = presenter.getTextForSection(indexPath.section) {
                cell.changeText(text)
            }
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter = presenter, indexPath.section >= 0 && indexPath.section < presenter.sections.count else {
            return 0
        }
        return UITableView.automaticDimension
    }
}

// MARK: - Header
extension EditProfileViewController {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let presenter = presenter, section >= 0 && section < presenter.sections.count else {
            return nil
        }
        return presenter.getSectionTitle(for: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let presenter = presenter, section >= 0 && section < presenter.sections.count else {
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
        guard let presenter = presenter, section >= 0 && section < presenter.sections.count else {
            return 0
        }
        return 28
    }
}

// MARK: - Footer
extension EditProfileViewController {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let presenter = presenter, section >= 0 && section < presenter.sections.count else {
            return nil
        }

        if presenter.shouldShowFooter(for: section) {
            return TableViewHeaderAndFooterHelper.configureFooterView()
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let presenter = presenter, section >= 0 && section < presenter.sections.count else {
            return 0
        }
        return presenter.shouldShowFooter(for: section) ? 30 : 24
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
