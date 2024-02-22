import XCTest
import Main
import UIMobile
import Validation

final class SignUpControllerFactoryTests: XCTestCase {
    func test_backgroundRequest_shouldCompleteOnMainThread() {
        let (sut, addAccountSpy) = makeSut()
        sut.loadViewIfNeeded()
        sut.signUp?(makeSignUpRequestModel())
        let exp = expectation(description: "waiting")
        DispatchQueue.global().async {
            addAccountSpy.completeWith(error: .unexpected)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_doInjectCorrectValidations() {
        let validations = makeSignUpValidations()
        XCTAssertEqual(
            validations[0] as! RequiredFieldValidation,
            RequiredFieldValidation(fieldName: "name", fieldLabel: "Name")
        ) 
        XCTAssertEqual(
            validations[1] as! RequiredFieldValidation,
            RequiredFieldValidation(fieldName: "email", fieldLabel: "Email")
        )
        XCTAssertEqual(
            validations[2] as! EmailValidation,
            EmailValidation(
                fieldName: "email",
                fieldLabel: "Email",
                emailValidator: EmailValidatorSpy()
            )
        )
        XCTAssertEqual(
            validations[3] as! RequiredFieldValidation,
            RequiredFieldValidation(fieldName: "password", fieldLabel: "Password")
        )
        XCTAssertEqual(
            validations[4] as! RequiredFieldValidation,
            RequiredFieldValidation(
                fieldName: "passwordConfirmation",
                fieldLabel: "Password Confirmation"
            )
        )
        XCTAssertEqual(
            validations[5] as! CompareFieldsValidation,
            CompareFieldsValidation(
                fieldName: "password",
                fieldNameToCompare: "passwordConfirmation",
                fieldLabel: "Password Confirmation"
            )
        )
    }
}

extension SignUpControllerFactoryTests {
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: SignUpViewController, addAccountSpy: AddAccountSpy) {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSignUpController(addAccount: MainDispatchQueueDecorator(addAccountSpy))
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: addAccountSpy, file: file, line: line)
        return (sut, addAccountSpy)
    }
}
