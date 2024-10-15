//
//  TextViewCell.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 15.10.2024.
//

import UIKit

final class TextViewCell: UITableViewCell, ReuseIdentifying {

    // MARK: - Private Properties
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(
            ofSize: 17,
            weight: .regular
        )
        textView.tintColor = .systemBlue
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 12
        textView.clipsToBounds = true
        textView.backgroundColor = .yplightGrey
        textView.textAlignment = .left
        textView.textContainerInset = UIEdgeInsets(
            top: 11,
            left: 16,
            bottom: 11,
            right: 16
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
        contentView.backgroundColor = .clear
        textView.delegate = self
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public methods
    func getText() -> UITextView {
        return textView
    }

    func changeText(_ text: String) {
        textView.text = text
    }
    // MARK: - Private Methods
    private func setupUI() {
        [textView, clearButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            clearButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -12),
            clearButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 17),
            clearButton.heightAnchor.constraint(equalToConstant: 17)
        ])
    }

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
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        clearButton.isHidden = true
    }
}
