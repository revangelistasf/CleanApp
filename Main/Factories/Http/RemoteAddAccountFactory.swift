import Data
import Domain

func makeRemoteAddAccount() -> AddAccount {
    return makeRemoteAddAccount(httpClient: makeAlamofireAdapter())
}

func makeRemoteAddAccount(httpClient: HttpPostClient) -> AddAccount {
    let remoteAddAccount = RemoteAddAccount(url: makeApiUrl(path: "signup"), httpClient: httpClient)
    return MainDispatchQueueDecorator(remoteAddAccount)
}
