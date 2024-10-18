//
//  ProtocolTableViewCell.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import UIKit

protocol NFTCellViewProtocol: AnyObject {
    func displayNFTName(_ name: String)
    func displayNFTRating(_ rating: Int)
    func displayNFTPrice(_ price: Double)
    func displayNFTImage(_ image: UIImage?)
}

protocol NFTCellPresenterProtocol {
    func loadNFTData()
    func deleteNFT(from viewController: UIViewController, at index: Int)
}
