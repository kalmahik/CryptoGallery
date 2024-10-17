//
//  CatalodRequest.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 16.10.2024.
//

import Foundation

struct CatalogRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.colectionsPath)")
    }
    var httpMethod: HttpMethod = .get
    var dto: Dto?
}
