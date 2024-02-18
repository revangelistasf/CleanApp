import Foundation
import Domain

func makeAccountModel() -> AccountModel {
    AccountModel(accessToken: "any_token")
}

func makeAddAccountModel() -> AddAccountModel {
    AddAccountModel(
        name: "any_name",
        email: "any_email@mail.com",
        password: "any_password",
        passwordConfirmation: "any_password"
    )
}
