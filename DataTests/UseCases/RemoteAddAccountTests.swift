import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
    func test_add_httpClientIsCalledWithCorrectUrl() {
        let url = makeUrl()
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
        expect(sut, completeWith: .failure(.unexpected)) {
            httpClientSpy.completeWith(.noConnectivity)
        }
    }

    func test_add_completeWithAccountModel_whenHttpClientCompleteWithValidData() {
        let (sut, httpClientSpy) = makeSut()
        let account = makeAccountModel()
        expect(sut, completeWith: .success(account)) {
            httpClientSpy.completeWith(account.toData()!)
        }
    }    

    func test_add_completeWithError_whenHttpClientCompleteWithInvalidData() {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected)) {
            httpClientSpy.completeWith(makeInvalidData())
        }
    }

    func test_add_doesNotComplete_sutHasBeenDeallocated() {
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: makeUrl(), httpClient: httpClientSpy)
        var result: Result<AccountModel, DomainError>?
        sut?.add(addAccountModel: makeAddAccountModel()) { result = $0 }
        sut = nil
        httpClientSpy.completeWith(.noConnectivity)
        XCTAssertNil(result)
    }
}

// MARK: - Helpers
extension RemoteAddAccountTests {
    func makeSut(
        url: URL = URL(string: "https://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        return (sut, httpClientSpy)
    }

    func expect(
        _ sut: RemoteAddAccount,
        completeWith expectedResult: Result<AccountModel, DomainError>,
        when action: () -> Void, 
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedAccount), .success(let receivedAccount)):
                XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) but found \(receivedResult) instead.", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }

    func makeAddAccountModel() -> AddAccountModel {
        AddAccountModel(
            name: "any_name",
            email: "any_email@mail.com",
            password: "any_password",
            passwordConfirmation: "any_password"
        )
    }

    func makeAccountModel() -> AccountModel {
        AccountModel(
            id: "any_id",
            name: "any_name",
            email: "any_email@mail.com",
            password: "any_password"
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

        func completeWith(_ data: Data) {
            completion?(.success(data))
        }
    }
}
