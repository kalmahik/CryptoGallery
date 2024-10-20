//
//  EnumCurrencyType.swift
//  FakeNFT
//
//  Created by Вадим on 18.10.2024.
//

import UIKit

enum CurrencyType: CaseIterable {
    case vts
    case usdt
    case sol
    case ada
    case doge
    case ape
    case eth
    case shib

    var logo: UIImage? {
        switch self {
        case .vts:
            return UIImage(named: "bitcoin")
        case .usdt:
            return UIImage(named: "tether")
        case .sol:
            return UIImage(named: "solana")
        case .ada:
            return UIImage(named: "cardano")
        case .doge:
            return UIImage(named: "dogecoin")
        case .ape:
            return UIImage(named: "apeCoin")
        case .eth:
            return UIImage(named: "ethereum")
        case .shib:
            return UIImage(named: "shibaInu")
        }
    }

    var fullName: String {
        switch self {
        case .vts:
            return "Bitcoin"
        case .usdt:
            return "Tether"
        case .sol:
            return "Solana"
        case .ada:
            return "Cardano"
        case .doge:
            return "Dogecoin"
        case .ape:
            return "Apecoin"
        case .eth:
            return "Ethereum"
        case .shib:
            return "Shiba Inu"
        }
    }

    var shortName: String {
        switch self {
        case .vts:
            return "ВТС"
        case .usdt:
            return "USDT"
        case .sol:
            return "SOL"
        case .ada:
            return "ADA"
        case .doge:
            return "DOGE"
        case .ape:
            return "APE"
        case .eth:
            return "ETH"
        case .shib:
            return "SHIB"
        }
    }
}
