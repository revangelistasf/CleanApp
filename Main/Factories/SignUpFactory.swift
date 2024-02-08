import Foundation
import UIMobile
import Presentation
import Validation
import Data
import Infra

class SignUpFactory {
    static func makeController() -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let url = URL(string: "https://clean-note-api.herokuapp.com/api/signup")!
        let alamofireAdapter = AlamofireAdapter()
        let remoteAddAccount = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
        let presenter = SignUpPresenter(
            alertView: controller,
            emailValidator: EmailValidatorAdapter(),
            addAccount: remoteAddAccount,
            loadingView: controller
        )
        
        controller.signUp = presenter.signUp
        return controller
    }
}
