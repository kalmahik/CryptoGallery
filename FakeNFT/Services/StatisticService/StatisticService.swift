import Foundation

typealias StatisticCompletion = (Result<StatisticResponse, Error>) -> Void

protocol StatisticService {
    func sendStatisticGetRequest(
        completion: @escaping StatisticCompletion
    )
}

final class StatisticNetworkServiceImpl: StatisticService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func sendStatisticGetRequest(completion: @escaping StatisticCompletion) {
        let dto = StatisticDtoObject()
        let request = StatisticRequest(dto: dto)
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
