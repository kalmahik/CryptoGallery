//
//  UIReting.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 10.10.2024.
//

import UIKit

final class UIRating: UIView {
    
    private var rating: Int = 0
    
    private lazy var ratingStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        
        for n in 1...5 {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            let image = UIImage(systemName: "star.fill")
            imageView.tintColor = n <= rating ? .ypYellowUniversal : .yplightGrey
            imageView.image = image
            imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            stackView.addArrangedSubview(imageView)
        }
        return stackView
    }()
    
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
    
    private func setupLayout() {
        addSubview(ratingStack)
        
        NSLayoutConstraint.activate([
            ratingStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingStack.topAnchor.constraint(equalTo: topAnchor),
            ratingStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            heightAnchor.constraint(equalToConstant: 12),
        ])
    }

}
