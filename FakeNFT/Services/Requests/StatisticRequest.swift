import Foundation

struct StatisticRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users")
    }
    var httpMethod: HttpMethod = .get
    var dto: Dto?
}

struct StatisticDtoObject: Dto {
//    let page: String
//    let size: String
//
//     enum CodingKeys: String, CodingKey {
//         case page = "page"
//         case size = "size"
//     }

    func asDictionary() -> [String: String] {
        [:]
    }
}

struct Statistic: Decodable {
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}

typealias StatisticResponse = [Statistic]
