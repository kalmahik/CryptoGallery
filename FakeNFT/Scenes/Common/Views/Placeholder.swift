//
//  Placeholder.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 21.10.2024.
//

import UIKit

final class Placeholder: UIView {

    // MARK: - Private Properties

    private let label = UILabel()

    // MARK: - Init

    init(text: String) {
        super.init(frame: .zero)
        configureView(text: text)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func update(text: String) {
        label.text = text
    }

    // MARK: - Private Methods

    private func configureView(text: String) {
        label.text = text
        label.font = .bold17
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.numberOfLines = 0

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = UIConstants.CornerRadius.small10
        stackView.addArrangedSubview(label)

        setupView(stackView)
        stackView.constraintCenters(to: self)
    }
}
