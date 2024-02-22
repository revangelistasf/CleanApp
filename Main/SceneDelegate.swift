import UIKit
import UIMobile

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private let loginControllerFactory: () -> LoginViewController = {
        let authentication = makeRemoteAuthentication(httpClient: makeAlamofireAdapter())
        return makeLoginController(authentication: authentication)
    }
    private let signUpControllerFactory: () -> SignUpViewController = {
        let addAccount = makeRemoteAddAccount(httpClient: makeAlamofireAdapter())
        return makeSignUpController(addAccount: addAccount)
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navController = NavigationController()
        let welcomeRouter = WelcomeRouter(
            navigationController: navController,
            loginControllerFactory: loginControllerFactory,
            signUpControllerFactory: signUpControllerFactory
        )
        let welcomeVC = WelcomeViewController.instantiate()
        welcomeVC.login = welcomeRouter.goToLogin
        welcomeVC.signUp = welcomeRouter.goToSignUp
        navController.setRootViewController(welcomeVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
