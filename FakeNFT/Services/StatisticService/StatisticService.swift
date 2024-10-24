import Foundation

typealias StatisticCompletion = (Result<StatisticResponse, Error>) -> Void

protocol StatisticService {
    func sendStatisticGetRequest(page: Int, size: Int, sortBy: SortBy, completion: @escaping StatisticCompletion)
    func saveSortBy(sortBy: SortBy)
    func getSortBy() -> SortBy
}

final class StatisticNetworkServiceImpl: StatisticService {
    private let networkClient: NetworkClient
    private let storage: StatisticStorage
    
    init(networkClient: NetworkClient, storage: StatisticStorage) {
        self.networkClient = networkClient
        self.storage = storage
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
    
    func saveSortBy(sortBy: SortBy) {
        self.storage.saveSortBy(sortBy)
    }
    
    func getSortBy() -> SortBy {
        self.storage.getSortBy()
    }
}
