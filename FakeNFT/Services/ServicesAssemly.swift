final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var catalogService: CatalogService {
        CatalogServiceImpl(networkClient: networkClient)
    }

    var collectionService: NFTService {
        NFTServiceImpl(networkClient: networkClient)
    }

    var likesService: LikesService {
        LikesServiceImpl(networkClient: networkClient)
    }
}
