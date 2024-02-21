import Foundation
import Domain

public final class RemoteAuthentication: Authentication {
    private let url: URL
    private let httpClient: HttpPostClient

    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }

    public func auth(
        authenticationModel: AuthenticationModel,
        completion: @escaping (Authentication.Result) -> Void
    ) {
        httpClient.post(to: url, with: authenticationModel.toData()) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                if let accountModel: AccountModel = data?.toModel() {
                    completion(.success(accountModel))
                } else {
                    completion(.failure(.unexpected))
                }
            case .failure(let networkError):
                switch networkError {
                case .unauthorized:
                    completion(.failure(.sessionExpired))
                default:
                    completion(.failure(.unexpected))
                }
            }
        }
    }
}
