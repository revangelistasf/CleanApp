import XCTest
import Domain
import Data

class RemoteAuthenticationTests: XCTestCase {
    func test_auth_httpClientIsCalledWithCorrectUrl() {
        let url = makeUrl()
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.auth(authenticationModel: makeAuthenticationModel()) { _ in }
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_auth_httpClientIsCalledWithCorrectData() {
        let (sut, httpClientSpy) = makeSut()
        let authenticationModel = makeAuthenticationModel()
        sut.auth(authenticationModel: authenticationModel) { _ in }
        XCTAssertEqual(httpClientSpy.data, authenticationModel.toData())
    }
    
    func test_auth_httpClientCompleteWithNoConnectivity_completeWithUnexpectedError() {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected)) {
            httpClientSpy.completeWith(.noConnectivity)
        }
    }
    
    func test_auth_httpClientCompleteWithUnauthorized_completeWithSessionExpiredError() {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.sessionExpired)) {
            httpClientSpy.completeWith(.unauthorized)
        }
    }

    func test_auth_doHttpClientSuccessWithValidData_completeWithAuthenticationModel() {
        let (sut, httpClientSpy) = makeSut()
        let account = makeAccountModel()
        expect(sut, completeWith: .success(account)) {
            httpClientSpy.completeWith(account.toData()!)
        }
    }
    
    func test_auth_doHttpClientSuccessWithInvalidData_completeWithAuthenticationModel() {
        let (sut, httpClientSpy) = makeSut()
        let account = makeAccountModel()
        expect(sut, completeWith: .failure(.unexpected)) {
            httpClientSpy.completeWith(makeInvalidData())
        }
    }
    
    
    func test_auth_doesSutDeallocated_doesNotComplete() {
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteAuthentication? = RemoteAuthentication(url: makeUrl(), httpClient: httpClientSpy)
        var result: Authentication.Result?
        sut?.auth(authenticationModel: makeAuthenticationModel()) { result = $0 }
        sut = nil
        httpClientSpy.completeWith(.noConnectivity)
        XCTAssertNil(result)
    }
}

// MARK: - Helpers
extension RemoteAuthenticationTests {
    func makeSut(
        url: URL = URL(string: "https://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteAuthentication, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAuthentication(url: url, httpClient: httpClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        return (sut, httpClientSpy)
    }

    func expect(
        _ sut: RemoteAuthentication,
        completeWith expectedResult: Authentication.Result,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "waiting")
        sut.auth(authenticationModel: makeAuthenticationModel()) { receivedResult in
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
}
