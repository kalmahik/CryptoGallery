final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let customNftStorage: CustomNftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        customNftStorage: CustomNftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.customNftStorage = customNftStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var customNftService: CustomNftService {
        CustomNftServiceImpl(networkClient: networkClient, storage: customNftStorage)
    }

    var profileService: ProfileService {
        ProfileServiceImpl(networkClient: networkClient)
    }
}
