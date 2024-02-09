import Foundation
import Data
import Infra
import Domain

final class UseCaseFactory {
    private static let httpClient: HttpPostClient = AlamofireAdapter()
    private static let baseUrl = "https://clean-note-api.herokuapp.com/api"
    
    private static func makeUrl(path: String) -> URL {
        return URL(string: "\(baseUrl)/\(path)")!
    }
    
    static func makeRemoteAddAccount() -> AddAccount {
        return RemoteAddAccount(url: makeUrl(path: "signup"), httpClient: httpClient)
    }
}
