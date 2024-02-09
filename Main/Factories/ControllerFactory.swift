import Foundation
import UIMobile
import Presentation
import Validation
import Domain

class ControllerFactory {
    static func makeSignUp(addAccount: AddAccount) -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let presenter = SignUpPresenter(
            alertView: WeakVarProxy(controller),
            emailValidator: EmailValidatorAdapter(),
            addAccount: addAccount,
            loadingView: WeakVarProxy(controller)
        )
        controller.signUp = presenter.signUp
        return controller
    }
}
