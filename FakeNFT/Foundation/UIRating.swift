//
//  UIRating.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 10.10.2024.
//

import UIKit

final class UIRating: UIView {

    // MARK: - Private Properties

    private var rating: Int = 0

    private lazy var ratingStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2

        for ratingValue in 1...5 {
            let star = starImageConfigure(active: ratingValue <= rating)
            stackView.addArrangedSubview(star)
        }
        return stackView
    }()

    // MARK: - Initializers

    init(rating: Int) {
        super.init(frame: .zero)
        self.rating = rating
        translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupLayout() {
        addSubview(ratingStack)

        NSLayoutConstraint.activate([
            ratingStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingStack.topAnchor.constraint(equalTo: topAnchor),
            ratingStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    // MARK: - Private Methods

    private func starImageConfigure(active: Bool) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "star.fill")
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.tintColor = active ? .ypYellowUniversal : .ypLightGrey
        return imageView
    }
}
