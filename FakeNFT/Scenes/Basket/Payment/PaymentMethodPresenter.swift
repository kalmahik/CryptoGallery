//
//  PaymentMethodPresenter.swift
//  FakeNFT
//
//  Created by Вадим on 18.10.2024.
//

import UIKit
import WebKit

final class PaymentMethodPresenter: PaymentMethodPresenterProtocol {

    // MARK: - Private Properties

    private weak var view: PaymentMethodViewProtocol?

    private var selectedCurrency: CurrencyType?
    private var viewController: UIViewController?

    // MARK: - Initializers

    init(view: PaymentMethodViewProtocol, viewController: UIViewController) {
        self.view = view
        self.viewController = viewController
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
        openTermsOfUse()
    }

    func updateSelectedCurrency(_ currency: CurrencyType) {
        selectedCurrency = currency
        print("Вы выбрали валюту: \(currency.shortName)")
    }

    func openTermsOfUse() {
        guard let view = viewController else { return }
        let webViewController = WebViewController(urlString: "https://yandex.ru/legal/practicum_termsofuse/")
        webViewController.modalPresentationStyle = .pageSheet
        view.present(webViewController, animated: true, completion: nil)
    }
}
