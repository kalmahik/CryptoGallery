//
//  TextViewCell.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 15.10.2024.
//

import UIKit

protocol TextViewCellDelegate: AnyObject {
    func textViewCell(_ cell: TextViewCell, didUpdateText text: String, for section: Int)
}

final class TextViewCell: UITableViewCell, ReuseIdentifying {

    // MARK: - Public Properties

    weak var delegate: TextViewCellDelegate?
    var section: Int?

    // MARK: - Private Properties

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .regular17
        textView.tintColor = .systemBlue
        textView.isScrollEnabled = false
        textView.applyCornerRadius(.small12)
        textView.backgroundColor = .ypLightGrey
        textView.textAlignment = .left
        textView.textContainerInset = UIEdgeInsets(
            top: UIConstants.Insets.medium11,
            left: UIConstants.Insets.medium16,
            bottom: UIConstants.Insets.medium11,
            right: UIConstants.Insets.medium16
        )
        return textView
    }()

    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .gray
        button.isHidden = true
        button.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .background
        textView.delegate = self
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure cell

extension TextViewCell {

    // MARK: - Public Methods

    func getText() -> UITextView {
        return textView
    }

    func changeText(_ text: String) {
        textView.text = text
    }
}

// MARK: - Layout

extension TextViewCell {

    // MARK: - Private Methods

    private func setupUI() {
        [textView, clearButton].forEach {
            contentView.setupView($0)
        }

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Padding.medium16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Padding.medium16),

            clearButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -UIConstants.Padding.medium12),
            clearButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: UIConstants.Square.clearButton),
            clearButton.heightAnchor.constraint(equalToConstant: UIConstants.Square.clearButton)
        ])
    }
}

// MARK: - Action

extension TextViewCell {
    @objc private func clearText() {
        textView.text = ""
        clearButton.isHidden = true
    }
}

// MARK: - TextViewDelegate

extension TextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        clearButton.isHidden = textView.text.isEmpty

        if let tableView = superview as? UITableView {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }

        if let section = section {
            delegate?.textViewCell(self, didUpdateText: textView.text, for: section)
        }
    }
}
