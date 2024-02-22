import XCTest
import Presentation
import Domain

final class LoginPresenterTests: XCTestCase {
    func test_login_shouldCallValidationWithCorrectValues() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validation: validationSpy)
        let loginRequest = makeLoginRequest()
        sut.login(viewModel: loginRequest)
        XCTAssertTrue(
            NSDictionary(dictionary: validationSpy.data!).isEqual(to: loginRequest.toJson()!)
        )
    }
    
    func test_login_validationFails_showErrorMessage() {
        let alertViewSpy = AlertViewSpy()
        let validationSpy = ValidationSpy()
        let sut = makeSut(alertView: alertViewSpy, validation: validationSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(
                viewModel,
                AlertViewModel(title: "Validation Failed", message: "Error")
            )
            exp.fulfill()
        }
        validationSpy.simulateError()
        sut.login(viewModel: makeLoginRequest())
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_authenticationWithValidValues() {
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(authentication: authenticationSpy)
        sut.login(viewModel: makeLoginRequest())
        XCTAssertEqual(authenticationSpy.authenticationModel, makeAuthenticationModel())
    }
    
    func test_login_authenticationFails_showGenericErrorAlert() {
        let alertViewSpy = AlertViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(authentication: authenticationSpy, alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        let alertViewModel = AlertViewModel(
            title: "Error",
            message: "Something went wrong, try again later."
        )
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel,alertViewModel)
            exp.fulfill()
        }
        sut.login(viewModel: makeLoginRequest())
        authenticationSpy.completeWith(error: .unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_authenticationFailsWithSessionExpired_showExpiredSessionErrorAlert() {
        let alertViewSpy = AlertViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(authentication: authenticationSpy, alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        let alertViewModel = AlertViewModel(
            title: "Error",
            message: "Invalid Email/Password combination."
        )
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel,alertViewModel)
            exp.fulfill()
        }
        sut.login(viewModel: makeLoginRequest())
        authenticationSpy.completeWith(error: .sessionExpired)
        wait(for: [exp], timeout: 1)
    }    

    func test_login_authenticationRequest_showSuccessAlertIfRequestIsSuccess() {
        let alertViewSpy = AlertViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(authentication: authenticationSpy, alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        let alertViewModel = AlertViewModel(
            title: "Success",
            message: "Login successfully."
        )
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, alertViewModel)
            exp.fulfill()
        }
        sut.login(viewModel: makeLoginRequest())
        authenticationSpy.completeWith(account: makeAccountModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_doIsLoadingOnAuthentication_StartLoadingBeforeAndStopAfter() {
        let loadingViewSpy = LoadingViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(authentication: authenticationSpy, loadingView: loadingViewSpy)
        let exp = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            exp.fulfill()
        }
        sut.login(viewModel: makeLoginRequest())
        wait(for: [exp], timeout: 1)

        let exp2 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            exp2.fulfill()
        }
        authenticationSpy.completeWith(error: .unexpected)
        wait(for: [exp2], timeout: 1)
    }
}

// MARK: - Helpers
extension LoginPresenterTests {
    func makeSut(
        authentication: Authentication = AuthenticationSpy(),
        alertView: AlertView = AlertViewSpy(),
        loadingView: LoadingView = LoadingViewSpy(),
        validation: Validation = ValidationSpy(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> LoginPresenter {
        let sut = LoginPresenter(
            authentication: authentication, 
            alertView: alertView,
            loadingView: loadingView,
            validation: validation
        )
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
