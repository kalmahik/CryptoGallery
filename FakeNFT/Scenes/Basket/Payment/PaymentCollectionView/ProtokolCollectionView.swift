//
//  ProtokolCollectionView.swift
//  FakeNFT
//
//  Created by Вадим on 18.10.2024.
//

import UIKit

protocol CollectionViewProtokol: AnyObject {
    func displayLogo(_ image: UIImage?)
    func displayFullName(_ name: String)
    func displayShortName(_ name: String)
}

protocol CurrencyCellPresenterProtocol {
    func configure(with currency: CurrencyType)
    func didTapCell()
}

protocol CurrencyCellDelegate: AnyObject {
    func didSelectCurrency(_ currency: CurrencyType)
}