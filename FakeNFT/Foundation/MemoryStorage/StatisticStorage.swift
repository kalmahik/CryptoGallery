import Foundation

protocol StatisticStorage: AnyObject {
    func saveSortBy(_ sortBy: SortBy)
    func getSortBy() -> SortBy
}

final class StatisticStorageImpl: StatisticStorage {
    private var sortBy: SortBy = .rating
    private let syncQueue = DispatchQueue(label: "sync-statistic-queue")

    func saveSortBy(_ sortBy: SortBy) {
        syncQueue.async { [weak self] in
            self?.sortBy = sortBy
        }
    }
    
    func getSortBy() -> SortBy {
        syncQueue.sync {
            sortBy
        }
    }
}
