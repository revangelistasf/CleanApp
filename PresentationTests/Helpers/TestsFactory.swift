import Foundation
import Presentation

func makeSignUpRequestModel(
    name: String? = "any_name",
    email: String? = "any_email@mail.com",
    password: String? = "any_password",
    passwordConfirmation: String? = "any_password"
) -> SignUpRequestModel {
    return SignUpRequestModel(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation
    )
}

func makeLoginRequest(
    email: String? = "any_email@mail.com",
    password: String? = "any_password"
) -> LoginRequest {
    return LoginRequest(email: email, password: password)
}
