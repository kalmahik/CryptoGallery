//
//  LikesRequest.swift
//  FakeNFT
//
//  Created by Глеб Хамин on 24.10.2024.
//

import Foundation

struct LikesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.profilePath)")
    }
    var httpMethod: HttpMethod = .get
    var dto: Dto?
}
