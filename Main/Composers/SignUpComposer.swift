import Foundation
import UIMobile
import Domain

public final class SignUpComposer {
    public static func composeController(with addAccount: AddAccount) -> SignUpViewController {
        return ControllerFactory.makeSignUp(addAccount: addAccount)
    }
}
