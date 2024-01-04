import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
    func test_add_httpClientIsCalledWithCorrectUrl() {
        let url = URL(string: "https://any-url.com")!
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: makeAddAccountModel()) { _ in }
        XCTAssertEqual(httpClientSpy.urls, [url])
    }

    func test_add_httpClientIsCalledWithCorrectData() {
        let (sut, httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel)  { _ in }
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
    }
    
    func test_add_completeWithError_whenHttpClientFails() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            if case let .failure(error) = result {
                XCTAssertEqual(error, .unexpected)
                exp.fulfill()
            }
        }
        
        httpClientSpy.completeWith(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
}

// MARK: - Helpers
extension RemoteAddAccountTests {
    func makeSut(
        url: URL = URL(string: "https://any-url.com")!
    ) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (sut, httpClientSpy)
    }

    func makeAddAccountModel() -> AddAccountModel {
        AddAccountModel(
            name: "any_name",
            email: "any_email@mail.com",
            password: "any_password",
            passwordConfirmation: "any_password"
        )
    }

    class HttpClientSpy: HttpPostClient {
        var urls = [URL]()
        var data: Data?
        var completion: ((Result<Data, NetworkError>) -> Void)?

        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }

        func completeWith(_ error: NetworkError) {
            completion?(.failure(error))
        }
    }
}
