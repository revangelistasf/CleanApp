import XCTest
import Main
import UIMobile

final class SignUpComposerTests: XCTestCase {
    func test_backgroundRequest_shouldCompleteOnMainThread() {
        let (sut, addAccountSpy) = makeSut()
        sut.loadViewIfNeeded()
        sut.signUp?(makeSignUpViewModel())
        let exp = expectation(description: "waiting")
        DispatchQueue.global().async {
            addAccountSpy.completeWith(error: .unexpected)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

extension SignUpComposerTests {
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: SignUpViewController, addAccountSpy: AddAccountSpy) {
        let addAccountSpy = AddAccountSpy()
        let sut = SignUpComposer.composeController(with: MainDispatchQueueDecorator(addAccountSpy))
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: addAccountSpy, file: file, line: line)
        return (sut, addAccountSpy)
    }
}
