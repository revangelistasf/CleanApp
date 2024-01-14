import XCTest
import Presentation
import Domain

class SignUpPresenterTests: XCTestCase {
    func test_signUp_showErrorMessage_doesNotHaveAName() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeMandatoryAlertViewModel(fieldName: "name"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel(name: nil))
        wait(for: [exp], timeout: 1)
    }

    func test_signUp_showErrorMessage_doesNotHaveAnEmail() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeMandatoryAlertViewModel(fieldName: "email"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel(email: nil))
        wait(for: [exp], timeout: 1)
    }

    func test_signUp_showErrorMessage_doesNotHaveAPassword() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeMandatoryAlertViewModel(fieldName: "password"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel(password: nil))
        wait(for: [exp], timeout: 1)
    }

    func test_signUp_showErrorMessage_doesNotHaveAPasswordConfirmation() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeMandatoryAlertViewModel(fieldName: "confirm password"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        wait(for: [exp], timeout: 1)
    }

    func test_signUp_showErrorMessage_passwordAndPasswordConfirmationDoesNotMatch() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeInvalidAlertViewModel(fieldName: "confirm password"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "wrong_password"))
        wait(for: [exp], timeout: 1)
    }

    func test_signUp_emailValidator_withInvalidEmail() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeInvalidAlertViewModel(fieldName: "email"))
            exp.fulfill()
        }
        emailValidatorSpy.simulateInvalidEmail()
        sut.signUp(viewModel: signUpViewModel)
        wait(for: [exp], timeout: 1)
    }

    func test_signUp_emailValidator_withValidEmail() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }

    func test_signUp_addAccountRequest_withValidValues() {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccount: addAccountSpy)
        sut.signUp(viewModel: makeSignUpViewModel())
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
    }

    func test_signUp_addAccountRequest_showErrorAlertIfRequestFails() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(
                viewModel,
                makeErrorAlertViewModel(message: "Something went wrong, try again later.")
            )
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completeWith(error: .unexpected)
        wait(for: [exp], timeout: 1)
    }

    func test_signUp_addAccountRequest_showSuccessAlertIfRequestIsSuccess() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(
                viewModel,
                makeSuccessAlertViewModel(message: "Account created successfully.")
            )
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completeWith(account: makeAccountModel())
        wait(for: [exp], timeout: 1)
    }

    func test_signUp_isLoading_BeforeAndAfterAddAccountWhenFail() {
        let addAccountSpy = AddAccountSpy()
        let loadingViewSpy = LoadingViewSpy()
        let sut = makeSut(addAccount: addAccountSpy, loadingView: loadingViewSpy)
        let exp = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpViewModel())
        wait(for: [exp], timeout: 1)

        let exp2 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            exp2.fulfill()
        }
        addAccountSpy.completeWith(error: .unexpected)
        wait(for: [exp2], timeout: 1)
    }
}

// MARK: - Helpers
extension SignUpPresenterTests {
    func makeSut(
        alertView: AlertView = AlertViewSpy(),
        emailValidator: EmailValidator = EmailValidatorSpy(),
        addAccount: AddAccount = AddAccountSpy(),
        loadingView: LoadingView = LoadingViewSpy(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SignUpPresenter {
        let sut = SignUpPresenter(
            alertView: alertView,
            emailValidator: emailValidator,
            addAccount: addAccount,
            loadingView: loadingView
        )
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }

    func makeSignUpViewModel(
        name: String? = "any_name",
        email: String? = "any_email@mail.com",
        password: String? = "any_password",
        passwordConfirmation: String? = "any_password"
    ) -> SignUpViewModel {
        return SignUpViewModel(
            name: name,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation
        )
    }
}
