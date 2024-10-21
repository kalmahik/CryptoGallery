import Foundation

struct StatisticRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users?page=\(page)&size=\(size)&sortBy=\(sortBy)")
    }
    var httpMethod: HttpMethod = .get
    var dto: Dto?
    var page: Int
    var size: Int
    var sortBy: SortBy
}

struct StatisticDtoObject: Dto {
//    let page: Int
//    let size: Int
//    let sortBy: SortBy

//     enum CodingKeys: String, CodingKey {
//         case page
//         case size
//         case sortBy
//     }

    func asDictionary() -> [String: String] {
        [:]
//        [
//            CodingKeys.page.rawValue: "\(page)",
//            CodingKeys.size.rawValue: "\(size)",
//            CodingKeys.sortBy.rawValue: "\(sortBy)"
//        ]
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
