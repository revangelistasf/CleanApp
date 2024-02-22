import XCTest
import UIKit
import Presentation
@testable import UIMobile

final class LoginViewControllerTests: XCTestCase {
    func test_loadingIsHidden_onStart() {
        XCTAssertEqual(makeSut().loadingIndicator?.isAnimating, false)
    }
    
    func test_protocolsImplementations() {
        let sut = makeSut()
        XCTAssertNotNil(sut as LoadingView)
        XCTAssertNotNil(sut as AlertView)
    }
    
    
    func test_loginButton_callsAuthOnTap() {
        var loginViewModel: LoginRequestModel?
        let sut = makeSut(loginViewModel: { loginViewModel = $0 })
        sut.loginButton?.simulateTap()
        let email = sut.emailTextField.text
        let password = sut.passwordTextField.text
        XCTAssertEqual(loginViewModel, LoginRequestModel(email: email, password: password))
    }
}

extension LoginViewControllerTests {
    private func makeSut(
        loginViewModel: ((LoginRequestModel) -> Void)? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> LoginViewController {
        let sut = LoginViewController.instantiate()
        sut.login = loginViewModel
        sut.loadViewIfNeeded()
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
