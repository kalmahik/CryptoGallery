//
//  CollectionViewPresenter.swift
//  FakeNFT
//
//  Created by Вадим on 18.10.2024.
//

import UIKit

final class CurrencyCellPresenter: CurrencyCellPresenterProtocol {

    // MARK: - Private Properties

    private weak var view: CollectionViewProtokol?

    private var currency: CurrencyType?
    private var isSelected: Bool = false

    // MARK: - Initializers

    init(view: CollectionViewProtokol) {
        self.view = view
    }

    // MARK: - Public Methods

    func configure(with currency: CurrencyType) {
        self.currency = currency
        view?.displayLogo(currency.logo)
        view?.displayFullName(currency.fullName)
        view?.displayShortName(currency.shortName)
    }

    func didTapCell() {
        isSelected.toggle()
        (view as? CurrencyCell)?.setSelected(isSelected)
    }
}
