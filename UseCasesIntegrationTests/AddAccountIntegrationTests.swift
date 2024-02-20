import XCTest
import Data
import Infra
import Domain

class AddAccountIntegrationTests: XCTestCase {
    func test_addAccount() {
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "http://localhost:5050/api/signup")!
        let sut = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
        let addAccountModel = AddAccountModel(
            name: "John Doe",
            email: "\(UUID().uuidString)@mail.com",
            password: "secret",
            passwordConfirmation: "secret"
        )
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { result in
            if case let .success(account) = result {
                XCTAssertNotNil(account.accessToken)
                exp.fulfill()
            } else {
                XCTFail("Expect success, got \(result) instead.")
            }
        }
        wait(for: [exp], timeout: 5)
        
        let exp2 = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { result in
            if case let .failure(error) = result, error == .emailInUse {
                exp2.fulfill()
            } else {
                XCTFail("Expect fail, got \(result) instead.")
            }
        }
        wait(for: [exp2], timeout: 5)
    }
}

