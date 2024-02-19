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
            name: "Roberto Evangelista",
            email: "robertoevangelistasf@gmail.com",
            password: "secret",
            passwordConfirmation: "secret"
        )
        let exp = expectation(description: "waiting")

        sut.add(addAccountModel: addAccountModel) { result in
            if case let .success(account) = result {
                XCTAssertNotNil(account.accessToken)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 5)
    }

}

