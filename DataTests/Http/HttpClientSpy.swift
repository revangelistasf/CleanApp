import Foundation
import Data

class HttpClientSpy: HttpPostClient {
    var urls = [URL]()
    var data: Data?
    var completion: ((Result<Data?, NetworkError>) -> Void)?

    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
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
