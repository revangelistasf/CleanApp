final class WelcomeRouter {
    private let navigationController: NavigationController
    private let loginControllerFactory: () -> LoginViewController
    private let signUpControllerFactory: () -> SignUpViewController
    
    public init(
        navigationController: NavigationController,
        loginControllerFactory: @escaping () -> LoginViewController,
        signUpControllerFactory: @escaping () -> SignUpViewController
    ) {
        self.navigationController = navigationController
        self.loginControllerFactory = loginControllerFactory
        self.signUpControllerFactory = signUpControllerFactory
    }
    
    public func goToLogin() {
        navigationController.pushViewController(loginControllerFactory())
    }
    
    public func goToSignUp() {
        navigationController.pushViewController(signUpControllerFactory())
    }
}
