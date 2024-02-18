import XCTest
import Presentation
import Validation

final class ValidationCompositeTests: XCTestCase {
    func test_validate_validationFails_shouldReturnError() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validations: [validationSpy])
        validationSpy.simulateError(with: "Generic error")
        let errorMessage = sut.validate(data: ["name" : "Roberto"])
        XCTAssertEqual(errorMessage, "Generic error")
    }    
    
    func test_validate_validationFails_shouldReturnErrorWithCorrectMessage() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validations: [validationSpy])
        validationSpy.simulateError(with: "Unexpected error")
        let errorMessage = sut.validate(data: ["name" : "Roberto"])
        XCTAssertEqual(errorMessage, "Unexpected error")
    }
        
    func test_validate_secondValidationFails_shouldReturnErrorWithCorrectMessage() {
        let validationSpy = ValidationSpy()
        let validationSpy2 = ValidationSpy()
        let sut = makeSut(validations: [validationSpy, validationSpy2])
        validationSpy2.simulateError(with: "Unexpected error 2")
        let errorMessage = sut.validate(data: ["name" : "Roberto"])
        XCTAssertEqual(errorMessage, "Unexpected error 2")
    }    
    
    func test_validate_twoValidationFails_shouldReturnErrorWithCorrectMessageInPriorityOrder() {
        let validationSpy = ValidationSpy()
        let validationSpy2 = ValidationSpy()
        let validationSpy3 = ValidationSpy()
        let sut = makeSut(validations: [validationSpy, validationSpy2, validationSpy3])
        validationSpy2.simulateError(with: "Unexpected error 2")
        validationSpy3.simulateError(with: "Unexpected error 3")
        let errorMessage = sut.validate(data: ["name" : "Roberto"])
        XCTAssertEqual(errorMessage, "Unexpected error 2")
    }
    
    func test_validate_doAllValidationsSuccess_shouldReturnNil() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validations: [validationSpy])
        XCTAssertNil(sut.validate(data: ["name" : "Roberto"]))
    }    
    
    func test_validate_callsValidationWithCorrectData() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validations: [validationSpy])
        let data = ["name" : "Roberto"]
        _ = sut.validate(data: data)
        XCTAssertTrue(NSDictionary(dictionary: validationSpy.data!).isEqual(to: data))
    }
}

extension ValidationCompositeTests {
    func makeSut(
        validations: [Validation],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Validation {
        let sut = ValidationComposite(validations: validations)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
