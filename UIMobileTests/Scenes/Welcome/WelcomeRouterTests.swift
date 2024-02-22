import XCTest
import UIKit
@testable import UIMobile

final class WelcomeRouter {
    private let navigationController: NavigationController
    private let loginFactory: () -> LoginViewController
    
    public init(
        navigationController: NavigationController,
        loginFactory: @escaping () -> LoginViewController
    ) {
        self.navigationController = navigationController
        self.loginFactory = loginFactory
    }
    
    func goToLogin() {
        navigationController.pushViewController(loginFactory())
    }
}

final class WelcomeRouterTests: XCTestCase {
    func test_login_goToLogin_navigationControllerPresentLoginViewController() {
        let navigationController = NavigationController()
        makeSut(navigationController: navigationController).goToLogin()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertTrue(navigationController.viewControllers.first is LoginViewController)
    }

}

extension WelcomeRouterTests {
    func makeSut(
        navigationController: NavigationController = NavigationController()
    ) -> WelcomeRouter {
        let loginFactorySpy = LoginFactorySpy()
        let sut = WelcomeRouter(
            navigationController: navigationController,
            loginFactory: loginFactorySpy.makeLogin
        )
        checkMemoryLeak(for: sut)
        return sut
    }
}

extension WelcomeRouterTests {
    class LoginFactorySpy {
        func makeLogin() -> LoginViewController {
            return LoginViewController.instantiate()
        }
    }
}
