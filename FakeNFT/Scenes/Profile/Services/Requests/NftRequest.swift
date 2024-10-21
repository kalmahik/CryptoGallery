//
//  NftRequest.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 21.10.2024.
//

import Foundation

struct NftRequest: NetworkRequest {
    var httpMethod: HttpMethod = .get
    var dto: Dto? = nil

    var endpoint: URL? {
        var components = URLComponents(string: "\(NetworkConstants.baseURL)\(NetworkConstants.nftPath)")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)"),
            URLQueryItem(name: "sort", value: sort.rawValue)
        ]
        return components?.url
    }

    let page: Int
    let size: Int
    let sort: NftSort

    enum NftSort: String {
        case rating = "rating"
        case price = "price"
        case name = "name"
    }
}
