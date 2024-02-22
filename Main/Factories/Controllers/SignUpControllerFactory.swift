import UIMobile
import Presentation
import Validation
import Domain

public func makeSignUpController() -> SignUpViewController {
    return makeSignUpController(addAccount: makeRemoteAddAccount())
}
public func makeSignUpController(addAccount: AddAccount) -> SignUpViewController {
    let controller = SignUpViewController.instantiate()
    let validationComposite = ValidationComposite(validations: makeSignUpValidations())
    let presenter = SignUpPresenter(
        alertView: WeakVarProxy(controller),
        addAccount: addAccount,
        loadingView: WeakVarProxy(controller),
        validation: validationComposite
    )
    controller.signUp = presenter.signUp
    return controller
}

public func makeSignUpValidations() -> [Validation] {
    return ValidationBuilder.field("name").label("Name").required().build() +
        ValidationBuilder.field("email").label("Email").required().email().build() +
        ValidationBuilder.field("password").label("Password").required().build() +
        ValidationBuilder.field("passwordConfirmation")
        .label("Password Confirmation")
        .required()
        .compreTo("password")
        .build()
}
