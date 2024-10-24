final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let statisticStorage: StatisticStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        statisticStorage: StatisticStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.statisticStorage = statisticStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var statisticService: StatisticService {
        StatisticNetworkServiceImpl(
            networkClient: networkClient,
            storage: statisticStorage
        )
    }
}
