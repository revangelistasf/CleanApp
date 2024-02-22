import XCTest
import UIKit
@testable import UIMobile

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

final class WelcomeRouterTests: XCTestCase {
    func test_goToLogin_navigationControllerPushLoginViewController() {
        let navigationController = NavigationController()
        makeSut(navigationController: navigationController).goToLogin()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is LoginViewController)
    }
    
    func test_goToSignUp_navigationControllerPushSignUpViewController() {
        let navigationController = NavigationController()
        makeSut(navigationController: navigationController).goToSignUp()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is SignUpViewController)
    }
}

extension WelcomeRouterTests {
    func makeSut(
        navigationController: NavigationController = NavigationController()
    ) -> WelcomeRouter {
        let loginControllerFactorySpy = LoginControllerFactorySpy()
        let signUpControllerFactorySpy = SignUpControllerFactorySpy()
        let sut = WelcomeRouter(
            navigationController: navigationController,
            loginControllerFactory: loginControllerFactorySpy.makeLogin,
            signUpControllerFactory: signUpControllerFactorySpy.makeSignUp
        )
        checkMemoryLeak(for: sut)
        return sut
    }
}

extension WelcomeRouterTests {
    class LoginControllerFactorySpy {
        func makeLogin() -> LoginViewController {
            return LoginViewController.instantiate()
        }
    }    
    
    class SignUpControllerFactorySpy {
        func makeSignUp() -> SignUpViewController {
            return SignUpViewController.instantiate()
        }
    }
}
