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
}

extension LoginViewControllerTests {
    private func makeSut() -> LoginViewController {
        let sut = LoginViewController.instantiate()
        sut.loadViewIfNeeded()
        return sut
    }
}
