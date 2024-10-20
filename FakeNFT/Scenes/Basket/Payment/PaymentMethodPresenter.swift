//
//  PaymentMethodPresenter.swift
//  FakeNFT
//
//  Created by Вадим on 18.10.2024.
//

import UIKit

final class PaymentMethodPresenter: PaymentMethodPresenterProtocol {

    // MARK: - Private Properties

    private weak var view: PaymentMethodViewProtocol?

    private var selectedCurrency: CurrencyType?

    // MARK: - Initializers

    init(view: PaymentMethodViewProtocol) {
        self.view = view
    }

    // MARK: - Public Methods

    func didTapPayButton() {
        if let currency = selectedCurrency {
            print("Оплата произведена с валютой \(currency.shortName)")
        } else {
            print("Вы не выбрали валюту!")
        }
    }

    func didTapAgreeButton() {
        print("Вы согласились")
    }

    func updateSelectedCurrency(_ currency: CurrencyType) {
        selectedCurrency = currency
        print("Вы выбрали валюту: \(currency.shortName)")
    }
}
