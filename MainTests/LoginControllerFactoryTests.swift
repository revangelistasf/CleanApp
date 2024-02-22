import XCTest
import Main
import UIMobile
import Validation

final class LoginControllerFactoryTests: XCTestCase {
    func test_backgroundRequest_shouldCompleteOnMainThread() {
        let (sut, authenticationSpy) = makeSut()
        sut.loadViewIfNeeded()
        sut.login?(makeLoginRequest())
        let exp = expectation(description: "waiting")
        DispatchQueue.global().async {
            authenticationSpy.completeWith(error: .unexpected)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_doInjectCorrectValidations() {
        let validations = makeLoginValidations()
        XCTAssertEqual(
            validations[0] as! RequiredFieldValidation,
            RequiredFieldValidation(fieldName: "email", fieldLabel: "Email")
        )
        XCTAssertEqual(
            validations[1] as! EmailValidation,
            EmailValidation(
                fieldName: "email",
                fieldLabel: "Email",
                emailValidator: EmailValidatorSpy()
            )
        )
        XCTAssertEqual(
            validations[2] as! RequiredFieldValidation,
            RequiredFieldValidation(fieldName: "password", fieldLabel: "Password")
        )
    }
}

extension LoginControllerFactoryTests {
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LoginViewController, authenticationSpy: AuthenticationSpy) {
        let authenticationSpy = AuthenticationSpy()
        let sut = makeLoginController(authentication: MainDispatchQueueDecorator(authenticationSpy))
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: authenticationSpy, file: file, line: line)
        return (sut, authenticationSpy)
    }
}
