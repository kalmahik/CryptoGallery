//
//  ProfileRequests.swift
//  FakeNFT
//
//  Created by Konstantin Lyashenko on 16.10.2024.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(NetworkConstants.baseURL)\(NetworkConstants.profilePath)")
    }
    var httpMethod: HttpMethod = .get
    var dto: Dto? = nil
}

struct UpdateProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(NetworkConstants.baseURL)\(NetworkConstants.profilePath)")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?

    init(dto: UpdateProfileDto) {
        self.dto = dto
    }
}
