//
//  LocalizationKey.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 08.10.2024.
//

import Foundation

enum LocalizationKey {
    
    // MARK: - Error
    enum Error: String {
        case network = "Error.network"
        case unknown = "Error.unknown"
        case repeatAction = "Error.repeat"
        case title = "Error.title"
        
        func localized() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    // MARK: - Tab
    enum Tab: String {
        case profile = "Tab.profile"
        case catalog = "Tab.catalog"
        case basket = "Tab.basket"
        case statistics = "Tab.statistics"
        
        func localized() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    // MARK: - Catalog
    enum Catalog: String {
        case openNft = "Catalog.openNft"
        case sortTitle = "Catalog.sort.title"
        case sortCloseButton = "Catalog.sort.close.button"
        case sortByName = "Catalog.sort.byName"
        case sortByQuantity = "Catalog.sort.byQuantity"
        case author = "Catalog.author"
        case price = "Catalog.price"
        case addBasketButton = "Catalog.addBasket.button"
        case sellersButton = "Catalog.sellers.button"
        
        func localized() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    // MARK: - Basket
    enum Basket: String {
        case price = "Basket.price"
        case forPayButton = "Basket.forPay.button"
        case deleteObjectAlert = "Basket.delete.object.allert"
        case deleteButtonAlert = "Basket.delete.button.allert"
        case backButtonAlert = "Basket.back.button.allert"
        case title = "Basket.title"
        case agreeDescription = "Basket.agree.description"
        case userAgree = "Basket.user.agree"
        case payButton = "Basket.pay.button"
        case sortTitle = "Basket.sort.title"
        case sortByPrice = "Basket.sort.byPrice"
        case sortByRating = "Basket.sort.byRating"
        case sortByName = "Basket.sort.byName"
        case sortCloseButton = "Basket.sort.close.button"
        case successPlaceholder = "Basket.success.placeholder"
        case backButton = "Basket.back.button"
        case payErrorAlert = "Basket.payError.alert"
        case cancelButtonAlert = "Basket.cancel.button.allert"
        case repeatButtonAlert = "Basket.repeat.button.allert"
        case emptyPlaceholder = "Basket.empty.placeholder"
        
        func localized() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    // MARK: - Profile
    enum Profile: String {
        case myNft = "Profile.myNft"
        case selectedNft = "Profile.selectedNft"
        case aboutDev = "Profile.aboutDev"
        case changeImage = "Profile.change.image"
        case downloadImage = "Profile.download.image"
        case editName = "Profile.edit.name"
        case editDescription = "Profile.edit.description"
        case editWebsite = "Profile.edit.website"
        case fromAuthor = "Profile.fromAuthor"
        case price = "Profile.price"
        case sortTitle = "Profile.sort.title"
        case sortByPrice = "Profile.sort.byPrice"
        case sortByRating = "Profile.sort.byRating"
        case sortByName = "Profile.sort.byName"
        case sortCloseButton = "Profile.sort.close.button"
        case emptyMyNftPlaceholder = "Profile.empty.myNft.placeholder"
        case emptySelectedNftPlaceholder = "Profile.empty.selectedNft.placeholder"
        
        func localized() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    // MARK: - Statistics
    enum Statistics: String {
        case sortTitle = "Stat.sort.title"
        case sortCloseButton = "Stat.sort.close.button"
        case sortByName = "Stat.sort.byName"
        case sortByRating = "Stat.sort.byRating"
        case userButton = "Stat.user.button"
        case collectionNft = "Stat.collectionNft"
        case emptyDataAlert = "Stat.emptyData.alert"
        case cancelButtonAlert = "Stat.cancel.button.allert"
        case repeatButtonAlert = "Stat.repeat.button.allert"
        
        func localized() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
}
