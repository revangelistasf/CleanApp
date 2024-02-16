import XCTest
import Presentation
import Validation

final class CompareFieldsValidationTests: XCTestCase {
    func test_validate_comparationFails_shouldReturnError() {
        let sut = makeSut(
            fieldName: "password",
            fieldNameToCompare: "passwordConfirmation",
            fieldLabel: "Password"
        )
        let errorMessage = sut.validate(data: makeWrongPasswordConfirmationData())
        XCTAssertEqual(errorMessage, "The field Password is invalid")
    }

    func test_validate_comparationFails_shouldReturnErrorWithCorrectFieldLabelName() {
        let sut = makeSut(
            fieldName: "password",
            fieldNameToCompare: "passwordConfirmation",
            fieldLabel: "Confirm Password"
        )
        let errorMessage = sut.validate(data: makeWrongPasswordConfirmationData())
        XCTAssertEqual(errorMessage, "The field Confirm Password is invalid")
    }
    
    func test_validate_dataDoesNotProvided_shouldReturnErrorMessage() {
        let sut = makeSut(
            fieldName: "password",
            fieldNameToCompare: "passwordConfirmation",
            fieldLabel: "Password"
        )
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual(errorMessage, "The field Password is invalid")
    }
    
    func test_validate_comparationIsSuccess_shouldReturnNil() {
        let sut = makeSut(
            fieldName: "password",
            fieldNameToCompare: "passwordConfirmation",
            fieldLabel: "Password"
        )
        let errorMessage = sut.validate(data: ["password" : "123", "passwordConfirmation": "123"])
        XCTAssertNil(errorMessage)
    }
}

extension CompareFieldsValidationTests {
    func makeSut(
        fieldName: String,
        fieldNameToCompare: String,
        fieldLabel: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Validation {
        let sut = CompareFieldsValidation(
            fieldName: fieldName,
            fieldNameToCompare: fieldNameToCompare,
            fieldLabel: fieldLabel
        )
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    private func makeWrongPasswordConfirmationData() -> [String : Any] {
        return ["password" : "123qwe", "passwordConfirmation": "qwe123"]
    }
}
