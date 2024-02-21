import XCTest
import UIKit
import Presentation
@testable import UIMobile

final class SignUpViewControllerTests: XCTestCase {
    func test_loadingIsHidden_onStart() {
        XCTAssertEqual(makeSut().loadingIndicator?.isAnimating, false)
    }
    
    func test_protocolsImplementations() {
        let sut = makeSut()
        XCTAssertNotNil(sut as LoadingView)
        XCTAssertNotNil(sut as AlertView)
    }    
    
    func test_saveButton_callsSignUpOnTap() {
        var signUpViewModel: SignUpViewModel?
        let sut = makeSut(signUpViewModel: { signUpViewModel = $0 })
        sut.saveButton?.simulateTap()
        let name = sut.nameTextField?.text
        let email = sut.emailTextField.text
        let password = sut.passwordTextField.text
        let passwordConfirmation = sut.passwordConfirmationTextField.text
        XCTAssertEqual(
            signUpViewModel,
            SignUpViewModel(
                name: name,
                email: email,
                password: password,
                passwordConfirmation: passwordConfirmation
            )
        )
    }
}

extension SignUpViewControllerTests {
    private func makeSut(
        signUpViewModel: ((SignUpViewModel) -> Void)? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SignUpViewController {
        let sut = SignUpViewController.instantiate()
        sut.signUp = signUpViewModel
        sut.loadViewIfNeeded()
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
