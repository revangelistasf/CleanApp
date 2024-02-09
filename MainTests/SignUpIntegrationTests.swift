import XCTest
import Main

final class SignUpIntegrationTests: XCTestCase {
    func test_mobileUI_presentation_integration() {
        let sut = SignUpComposer.composeController(with: AddAccountSpy())
        checkMemoryLeak(for: sut)
    }
}
