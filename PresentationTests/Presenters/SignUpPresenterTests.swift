import XCTest
import Presentation

class SignUpPresenterTests: XCTestCase {
    func test_signUp_showErrorMessage_doesNotHaveAName() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(name: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeMandatoryAlertViewModel(fieldName: "name"))
    }

    func test_signUp_showErrorMessage_doesNotHaveAnEmail() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(email: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeMandatoryAlertViewModel(fieldName: "email"))
    }

    func test_signUp_showErrorMessage_doesNotHaveAPassword() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(password: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeMandatoryAlertViewModel(fieldName: "password"))
    }

    func test_signUp_showErrorMessage_doesNotHaveAPasswordConfirmation() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeMandatoryAlertViewModel(fieldName: "confirm password"))
    }

    func test_signUp_showErrorMessage_passwordAndPasswordConfirmationDoesNotMatch() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "wrong_password"))
        XCTAssertEqual(alertViewSpy.viewModel, makeInvalidAlertViewModel(fieldName: "confirm password"))
    }

    func test_signUp_emailValidator_withInvalidEmail() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()
        emailValidatorSpy.simulateInvalidEmail()
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeInvalidAlertViewModel(fieldName: "email"))
    }

    func test_signUp_emailValidator_withValidEmail() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
}

// MARK: - Helpers
extension SignUpPresenterTests {
    func makeSut(
        alertView: AlertView = AlertViewSpy(),
        emailValidator: EmailValidator = EmailValidatorSpy()
    ) -> SignUpPresenter {
        SignUpPresenter(alertView: alertView, emailValidator: emailValidator)
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

    func makeMandatoryAlertViewModel(fieldName: String) -> AlertViewModel {
        AlertViewModel(title: "Validation Failed", message: "The field \(fieldName) is mandatory")
    }

    func makeInvalidAlertViewModel(fieldName: String) -> AlertViewModel {
        AlertViewModel(title: "Validation Failed", message: "Please enter a valid \(fieldName) field")
    }

    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?

        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }

    class EmailValidatorSpy: EmailValidator {
        var isValid = true
        var email: String?

        func isValid(email: String) -> Bool {
            self.email = email
            return isValid
        }

        func simulateInvalidEmail() {
            isValid = false
        }
    }
}
