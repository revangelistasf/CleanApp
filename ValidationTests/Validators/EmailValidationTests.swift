import XCTest
import Presentation
import Validation

final class EmailValidationTests: XCTestCase {
    func test_validate_invalidEmailProvided_shouldReturnError() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(
            fieldName: "email",
            fieldLabel: "Email",
            emailValidator: emailValidatorSpy
        )
        emailValidatorSpy.simulateInvalidEmail()
        let errorMessage = sut.validate(data: ["email": "invalid_email@mail"])
        XCTAssertEqual(errorMessage, "The field Email is invalid")
    }

    func test_validate_invalidEmailProvided_shouldReturnErrorWithCorrectFieldLabel() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(
            fieldName: "email",
            fieldLabel: "Email2",
            emailValidator: emailValidatorSpy
        )
        emailValidatorSpy.simulateInvalidEmail()
        let errorMessage = sut.validate(data: ["email": "invalid_email@mail"])
        XCTAssertEqual(errorMessage, "The field Email2 is invalid")
    }
    
    func test_validate_dataDoesNotProvided_shouldReturnErrorMessage() {
        let sut = makeSut(
            fieldName: "email",
            fieldLabel: "Email",
            emailValidator: EmailValidatorSpy()
        )
        XCTAssertEqual(sut.validate(data: nil), "The field Email is invalid")
    }
    
    func test_validate_validEmailProvided_shouldReturnNil() {
        let sut = makeSut(
            fieldName: "email",
            fieldLabel: "Email2",
            emailValidator: EmailValidatorSpy()
        )
        
        XCTAssertNil(sut.validate(data: ["email": "valid_email@mail.com"]))
    }
}

extension EmailValidationTests {
    func makeSut(
        fieldName: String,
        fieldLabel: String,
        emailValidator: EmailValidator,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Validation {
        let sut = EmailValidation(
            fieldName: fieldName,
            fieldLabel: fieldLabel,
            emailValidator: emailValidator
        )
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
