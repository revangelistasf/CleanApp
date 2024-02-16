import XCTest
import Presentation
import Validation

final class RequiredFieldValidationTests: XCTestCase {
    func test_validate_fieldDoesNotProvided_shouldReturnError() {
        let sut = makeSut()
        let errorMessage = sut.validate(data: ["name" : "Roberto"])
        XCTAssertEqual(errorMessage, "The field Email is mandatory")
    }
    
    func test_validate_fieldDoesNotProvided_shouldReturnErrorWithCorrectFieldLabelName() {
        let sut = makeSut(fieldName: "password", fieldLabel: "Password")
        let errorMessage = sut.validate(data: ["name" : "Roberto"])
        XCTAssertEqual(errorMessage, "The field Password is mandatory")
    }

    func test_validate_dataDoesNotProvided_shouldReturnErrorMessage() {
        let sut = makeSut()
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual(errorMessage, "The field Email is mandatory")
    }
    
    func test_validate_fieldProvided_shouldReturnNil() {
        let sut = makeSut()
        let errorMessage = sut.validate(data: ["email" : "roberto@mail.com"])
        XCTAssertNil(errorMessage)
    }
}

extension RequiredFieldValidationTests {
    func makeSut(
        fieldName: String = "email",
        fieldLabel: String = "Email",
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Validation {
        let sut = RequiredFieldValidation(fieldName: fieldName, fieldLabel: fieldLabel)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
