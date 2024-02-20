import Foundation
import Domain

class AddAccountSpy: AddAccount {
    var addAccountModel: AddAccountModel?
    var completion: ((AddAccount.Result) -> Void)?

    func add(
        addAccountModel: AddAccountModel,
        completion: @escaping (AddAccount.Result) -> Void
    ) {
        self.addAccountModel = addAccountModel
        self.completion = completion
    }

    func completeWith(error: DomainError) {
        completion?(.failure(error))
    }

    func completeWith(account: AccountModel) {
        completion?(.success(account))
    }
}
