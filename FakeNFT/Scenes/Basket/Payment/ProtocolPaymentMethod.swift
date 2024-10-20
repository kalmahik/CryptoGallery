//
//  ProtocolPaymentMethod.swift
//  FakeNFT
//
//  Created by Вадим on 18.10.2024.
//

import Foundation

protocol PaymentMethodViewProtocol: AnyObject {
    func displayPaymentSuccess()
    func displayAgreementConfirmation()
}

protocol PaymentMethodPresenterProtocol {
    func didTapPayButton()
    func didTapAgreeButton()
    func updateSelectedCurrency(_ currency: CurrencyType)
    func openTermsOfUse()
}
