import Foundation
import UIMobile
import Presentation
import Validation
import Domain

public final class SignUpComposer {
    public static func composeController(with addAccount: AddAccount) -> SignUpViewController {
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
