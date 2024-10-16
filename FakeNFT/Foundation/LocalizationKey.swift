//
//  LocalizationKey.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 08.10.2024.
//

import Foundation

enum LocalizationKey: String {
    // Error
    case errorNetwork = "Error.network"
    case errorUnknown = "Error.unknown"
    case errorRepeat = "Error.repeat"
    case errorTitle = "Error.title"

    // Error messages
    case errorNetworkDescription = "Error.networkDescription"
    case errorUnauthorized = "Error.unauthorized"
    case errorBadRequest = "Error.badRequest"
    case errorProfileNotFound = "Error.profileNotFound"
    case errorServer = "Error.server"
    case errorServiceUnavailable = "Error.serviceUnavailable"
    case errorUpdateProfile = "Error.updateProfile"

    // MARK: - Common Actions
    case actionRetry = "Action.retry"
    case actionEdit = "Action.edit"
    case actionCancel = "Action.cancel"
    case actionClose = "Action.close"
    case actionSave = "Action.save"

    // Tab
    case tabProfile = "Tab.profile"
    case tabCatalog = "Tab.catalog"
    case tabBasket = "Tab.basket"
    case tabStatistics = "Tab.statistics"

    // Sort
    case sortTitle = "Sort.title"
    case sortByName = "Sort.byName"
    case sortByPrice = "Sort.byPrice"
    case sortByRating = "Sort.byRating"
    case sortByQuantity = "Sort.byQuantity"

    // Global
    case close = "Close"
    case price = "Price"
    case delete = "Delete"
    case back = "Back"
    case pay = "Pay"
    case cancel = "Cancel"
    case repeatAction = "Repeat"

    // Catalog
    case catOpenNft = "Catalog.openNft"
    case catAuthor = "Catalog.author"
    case catAddBasketButton = "Catalog.addBasket.button"
    case catSellersButton = "Catalog.sellers.button"

    // Basket
    case basketForPayButton = "Basket.forPay.button"
    case basketAlert = "Basket.allert"
    case basketTitle = "Basket.title"
    case basketAgreeDescription = "Basket.agree.description"
    case basketUserAgree = "Basket.user.agree"
    case basketSuccessPlaceholder = "Basket.success.placeholder"
    case basketBackButton = "Basket.back.button"
    case basketPayErrorAlert = "Basket.payError.alert"
    case basketEmptyPlaceholder = "Basket.empty.placeholder"

    // Profile
    case profMyNft = "Profile.myNft"
    case profSelectedNft = "Profile.selectedNft"
    case profAboutDev = "Profile.aboutDev"
    case profChangeImage = "Profile.change.image"
    case profDownloadImage = "Profile.download.image"
    case profEditName = "Profile.edit.name"
    case profEditDescription = "Profile.edit.description"
    case profEditWebsite = "Profile.edit.website"
    case profFromAuthor = "Profile.fromAuthor"
    case profMyNftPlaceholder = "Profile.myNft.placeholder"
    case profSelectedNftPlaceholder = "Profile.selectedNft.placeholder"

    // Statistics
    case statUserButton = "Stat.user.button"
    case statCollectionNft = "Stat.collectionNft"
    case statEmptyDataAlert = "Stat.emptyData.alert"

    // Shimmer
    case shimmerLoading = "Shimmer.loading"

    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
