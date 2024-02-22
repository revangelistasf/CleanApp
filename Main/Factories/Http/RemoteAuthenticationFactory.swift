import Data
import Domain

func makeRemoteAuthentication() -> Authentication {
    return makeRemoteAuthentication(httpClient: makeAlamofireAdapter())
}

func makeRemoteAuthentication(httpClient: HttpPostClient) -> Authentication {
    let remoteAuthentication = RemoteAuthentication(
        url: makeApiUrl(
            path: "login"
        ),
        httpClient: httpClient
    )
    return MainDispatchQueueDecorator(remoteAuthentication)
}
