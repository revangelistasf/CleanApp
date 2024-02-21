import XCTest
import Presentation
import Domain

final class LoginPresenterTests: XCTestCase {
    func test_login_shouldCallValidationWithCorrectValues() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validation: validationSpy)
        let viewModel = makeLoginViewModel()
        sut.login(viewModel)
        XCTAssertTrue(
            NSDictionary(
                dictionary: validationSpy.data!
            ).isEqual(to: viewModel.toJson()!)
        )
    }
}

// MARK: - Helpers
extension LoginPresenterTests {
    func makeSut(
        validation: Validation = ValidationSpy(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> LoginPresenter {
        let sut = LoginPresenter(
            validation: validation
        )
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
