import Foundation

typealias StatisticCompletion = (Result<StatisticResponse, Error>) -> Void

protocol StatisticService {
    func sendStatisticGetRequest(page: Int, size: Int, sortBy: SortBy, completion: @escaping StatisticCompletion)
}

final class StatisticNetworkServiceImpl: StatisticService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func sendStatisticGetRequest(
        page: Int,
        size: Int,
        sortBy: SortBy,
        completion: @escaping StatisticCompletion
    ) {
        let dto = StatisticDtoObject()
        let request = StatisticRequest(dto: dto, page: page, size: size, sortBy: sortBy)
        networkClient.send(request: request, type: StatisticResponse.self) { result in
            switch result {
            case .success(let putResponse):
                completion(.success(putResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
