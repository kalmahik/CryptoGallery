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

    // MARK: - Initializers

    init(view: PaymentMethodViewProtocol) {
        self.view = view
    }

    // MARK: - Public Methods

    func didTapPayButton() {
        view?.displayPaymentSuccess()
    }

    func didTapAgreeButton() {
        view?.displayAgreementConfirmation()
    }
}
