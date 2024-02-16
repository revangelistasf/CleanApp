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
            addAccount: addAccount,
            loadingView: WeakVarProxy(controller),
            validation: Validation()
        )
        controller.signUp = presenter.signUp
        return controller
    }
}
