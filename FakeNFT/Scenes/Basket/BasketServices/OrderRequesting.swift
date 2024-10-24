//
//  OrderRequesting.swift
//  FakeNFT
//
//  Created by Вадим on 23.10.2024.
//

import Foundation

struct OrderRequesting: NetworkRequest {
    var endpoint: URL? { return URL(string: "\(RequestConstants.baseURL)\(RequestConstants.orderPath)") }
    var httpMethod: HttpMethod { return .get }
    var dto: Dto? { return nil }
}
