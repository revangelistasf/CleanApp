import UIMobile
import Domain

public func makeWelcomeController(
    navigationController: NavigationController
) -> WelcomeViewController {
    let welcomeRouter = WelcomeRouter(
        navigationController: navigationController,
        loginControllerFactory: makeLoginController,
        signUpControllerFactory: makeSignUpController
    )
    let welcomeVC = WelcomeViewController.instantiate()
    welcomeVC.login = welcomeRouter.goToLogin
    welcomeVC.signUp = welcomeRouter.goToSignUp
    return welcomeVC
}
