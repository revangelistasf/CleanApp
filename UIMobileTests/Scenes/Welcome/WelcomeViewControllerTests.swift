import XCTest
import UIKit
import Presentation
@testable import UIMobile

final class WelcomeViewControllerTests: XCTestCase {
    func test_loginButton_callsLoginOnTap() {
        let buttonSpy = ButtonSpy()
        let sut = makeSut(buttonSpy: buttonSpy)
        sut.loginButton?.simulateTap()
        XCTAssertEqual(buttonSpy.clicks, 1)
    }

    func test_signUpButton_callsSignUpOnTap() {
        let buttonSpy = ButtonSpy()
        let sut = makeSut(buttonSpy: buttonSpy)
        sut.signUpButton?.simulateTap()
        XCTAssertEqual(buttonSpy.clicks, 1)
    }
}

extension WelcomeViewControllerTests {
    private func makeSut(
        buttonSpy: ButtonSpy = ButtonSpy(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> WelcomeViewController {
        let sut = WelcomeViewController.instantiate()
        sut.login = buttonSpy.onClick
        sut.signUp = buttonSpy.onClick
        sut.loadViewIfNeeded()
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    class ButtonSpy {
        var clicks = 0
        
        func onClick() {
            clicks += 1
        }
    }
}
