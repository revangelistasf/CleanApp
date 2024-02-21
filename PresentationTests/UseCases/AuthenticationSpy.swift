import Foundation
import Domain

class AuthenticationSpy: Authentication {
    var authenticationModel: AuthenticationModel?
    var completion: ((Authentication.Result) -> Void)?
    
    func auth(
        authenticationModel: AuthenticationModel,
        completion: @escaping (Authentication.Result) -> Void
    ) {
        self.authenticationModel = authenticationModel
        self.completion = completion
    }

    func completeWith(error: DomainError) {
        completion?(.failure(error))
    }

    func completeWith(account: AccountModel) {
        completion?(.success(account))
    }
}
