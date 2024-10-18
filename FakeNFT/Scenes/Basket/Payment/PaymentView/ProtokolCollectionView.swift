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
    func didTapCellButton(currency: CurrencyType?)
}

protocol CurrencyCellPresenterProtocol {
    func configure(with currency: CurrencyType)
}
