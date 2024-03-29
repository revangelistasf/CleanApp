import XCTest
import Presentation
import Domain

class SignUpPresenterTests: XCTestCase {
    func test_signUp_addAccountRequest_withValidValues() {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccount: addAccountSpy)
        sut.signUp(requestModel: makeSignUpRequestModel())
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
    }

    func test_signUp_addAccountFails_showGenericErrorAlert() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        let alertViewModel = AlertViewModel(
            title: "Error",
            message: "Something went wrong, try again later."
        )
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel,alertViewModel)
            exp.fulfill()
        }
        sut.signUp(requestModel: makeSignUpRequestModel())
        addAccountSpy.completeWith(error: .unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_addAccountFailsWithEmailInUseStatus_showEmailInUseErrorAlert() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        let alertViewModel = AlertViewModel(
            title: "Error",
            message: "This email is already in use."
        )
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel,alertViewModel)
            exp.fulfill()
        }
        sut.signUp(requestModel: makeSignUpRequestModel())
        addAccountSpy.completeWith(error: .emailInUse)
        wait(for: [exp], timeout: 1)
    }

    func test_signUp_addAccountRequest_showSuccessAlertIfRequestIsSuccess() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        let alertViewModel = AlertViewModel(
            title: "Success",
            message: "Account created successfully."
        )
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, alertViewModel)
            exp.fulfill()
        }
        sut.signUp(requestModel: makeSignUpRequestModel())
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
        sut.signUp(requestModel: makeSignUpRequestModel())
        wait(for: [exp], timeout: 1)

        let exp2 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            exp2.fulfill()
        }
        addAccountSpy.completeWith(error: .unexpected)
        wait(for: [exp2], timeout: 1)
    }
    
    func test_signUp_shouldCallValidationWithCorrectValues() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validation: validationSpy)
        let requestModel = makeSignUpRequestModel()
        sut.signUp(requestModel: requestModel)
        XCTAssertTrue(
            NSDictionary(dictionary: validationSpy.data!).isEqual(to: requestModel.toJson()!)
        )
    }
    
    func test_signUp_validationFails_showErrorMessage() {
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
        sut.signUp(requestModel: makeSignUpRequestModel())
        wait(for: [exp], timeout: 1)
    }
}

// MARK: - Helpers
extension SignUpPresenterTests {
    func makeSut(
        alertView: AlertView = AlertViewSpy(),
        addAccount: AddAccount = AddAccountSpy(),
        loadingView: LoadingView = LoadingViewSpy(),
        validation: Validation = ValidationSpy(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SignUpPresenter {
        let sut = SignUpPresenter(
            alertView: alertView,
            addAccount: addAccount,
            loadingView: loadingView,
            validation: validation
        )
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
