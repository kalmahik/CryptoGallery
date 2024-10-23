//
//  NFTRequesting.swift
//  FakeNFT
//
//  Created by Вадим on 23.10.2024.
//

import Foundation

struct NFTRequesting: NetworkRequest {
    let nftId: String

    var endpoint: URL? { return URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(nftId)") }
    var httpMethod: HttpMethod { return .get }
    var dto: Dto? { return nil }
}
