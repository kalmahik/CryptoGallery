//
//  ProtocolTableViewCell.swift
//  FakeNFT
//
//  Created by Вадим on 13.10.2024.
//

import UIKit

protocol NFTCellView: AnyObject {
    func displayNFTName(_ name: String)
    func displayNFTRating(_ rating: Int)
    func displayNFTPrice(_ price: String)
    func displayNFTImage(_ image: UIImage?)
}
