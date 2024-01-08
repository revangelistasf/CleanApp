import XCTest

public final class SignUpPresenter {
    private let alertView: AlertView

    init(alertView: AlertView) {
        self.alertView = alertView
    }

    func signUp(viewModel: SignUpViewModel) {
        if let message = validate(viewModel: viewModel) {
            alertView.showMessage(
                viewModel: AlertViewModel(title: "Validation Failed", message: message)
            )
        }
    }

    private func validate(viewModel: SignUpViewModel) -> String? {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            return "The field name is mandatory"
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "The field email is mandatory"
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "The field password is mandatory"
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return "The field confirm password is mandatory"
        }
        return nil
    }
}

protocol AlertView {
    func showMessage(viewModel: AlertViewModel)
}

struct AlertViewModel: Equatable {
    var title: String
    var message: String
}

struct SignUpViewModel {
    var name: String?
    var email: String?
    var password: String?
    var passwordConfirmation: String?
}

class SignUpPresenterTests: XCTestCase {
    func test_signUp_showErrorMessage_doesNotHaveAName() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(
            email: "any_email@mail.com",
            password: "any_password",
            passwordConfirmation: "any_password"
        )

        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(
            alertViewSpy.viewModel,
            AlertViewModel(title: "Validation Failed", message: "The field name is mandatory")
        )
    }

    func test_signUp_showErrorMessage_doesNotHaveAnEmail() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(
            name: "any_name",
            password: "any_password",
            passwordConfirmation: "any_password"
        )

        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(
            alertViewSpy.viewModel,
            AlertViewModel(title: "Validation Failed", message: "The field email is mandatory")
        )
    }

    func test_signUp_showErrorMessage_doesNotHaveAPassword() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(
            name: "any_name",
            email: "any_email@mail.com",
            passwordConfirmation: "any_password"
        )

        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(
            alertViewSpy.viewModel,
            AlertViewModel(title: "Validation Failed", message: "The field password is mandatory")
        )
    }

    func test_signUp_showErrorMessage_doesNotHaveAPasswordConfirmation() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(
            name: "any_name",
            email: "any_email@mail.com",
            password: "any_password"
        )

        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(
            alertViewSpy.viewModel,
            AlertViewModel(
                title: "Validation Failed",
                message: "The field confirm password is mandatory"
            )
        )
    }
}

extension SignUpPresenterTests {
    func makeSut() -> (sut: SignUpPresenter, alertViewSpy: AlertViewSpy) {
        let alertViewSpy = AlertViewSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy)
        return (sut, alertViewSpy)
    }

    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?

        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
