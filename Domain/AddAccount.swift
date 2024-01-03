import Foundation

// This will be my first use case
protocol AddAccount {
    func add(
        addAccountModel: AddAccountModel,
        completion: @escaping (Result<AccountModel, Error>) -> Error
    )
}

struct AddAccountModel {
    var name: String
    var email: String
    var password: String
    var passwordConfirmation: String
}

struct AccountModel {
    var id: String
    var name: String
    var email: String
    var password: String
}
