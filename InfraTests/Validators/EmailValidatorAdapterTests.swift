import XCTest
import Infra

final class EmailValidatorAdapterTests: XCTestCase {
    func test_invalidEmails() {
        let sut = makeSut()
        XCTAssertFalse(sut.isValid(email: ""))
        XCTAssertFalse(sut.isValid(email: "rrr"))
        XCTAssertFalse(sut.isValid(email: "rrr@"))
        XCTAssertFalse(sut.isValid(email: "rrr@rrr"))
        XCTAssertFalse(sut.isValid(email: "rrr@rrr."))
        XCTAssertFalse(sut.isValid(email: "@"))
        XCTAssertFalse(sut.isValid(email: "@rrr"))
        XCTAssertFalse(sut.isValid(email: "@rrr."))
        XCTAssertFalse(sut.isValid(email: "rrr."))
    }

    func test_validEmails() {
        let sut = makeSut()
        XCTAssertTrue(sut.isValid(email: "roberto@gmail.com"))
        XCTAssertTrue(sut.isValid(email: "roberto7@gmail.com"))
        XCTAssertTrue(sut.isValid(email: "roberto@msn.com"))
        XCTAssertTrue(sut.isValid(email: "roberto7@gmail.com.br"))
        XCTAssertTrue(sut.isValid(email: "roberto7@gmail.dev"))
    }
}

extension EmailValidatorAdapterTests {
    private func makeSut() -> EmailValidatorAdapter {
        EmailValidatorAdapter()
    }
}
