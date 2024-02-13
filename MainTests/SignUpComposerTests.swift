import XCTest
import Main
import UIMobile

final class SignUpComposerTests: XCTestCase {
    func test_backgroundRequest_shouldCompleteOnMainThread() {
        let (sut, addAccountSpy) = makeSut()
        sut.loadViewIfNeeded()
    }
}

extension SignUpComposerTests {
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: SignUpViewController, addAccountSpy: AddAccountSpy) {
        let addAccountSpy = AddAccountSpy()
        let sut = SignUpComposer.composeController(with: addAccountSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: addAccountSpy, file: file, line: line)
        return (sut, addAccountSpy)
    }
}
