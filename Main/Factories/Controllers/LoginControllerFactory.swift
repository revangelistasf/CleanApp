import UIMobile
import Presentation
import Validation
import Domain

public func makeLoginController() -> LoginViewController {
    return makeLoginController(authentication: makeRemoteAuthentication())
}

public func makeLoginController(authentication: Authentication) -> LoginViewController {
    let controller = LoginViewController.instantiate()
    let validationComposite = ValidationComposite(validations: makeLoginValidations())
    let presenter = LoginPresenter(
        authentication: authentication,
        alertView: WeakVarProxy(controller),
        loadingView: WeakVarProxy(controller),
        validation: validationComposite
    )
    controller.login = presenter.login
    return controller
}

public func makeLoginValidations() -> [Validation] {
    return ValidationBuilder.field("email").label("Email").required().email().build() +
        ValidationBuilder.field("password").label("Password").required().build()
}
