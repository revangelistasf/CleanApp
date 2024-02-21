import Foundation
import Domain

public final class MainDispatchQueueDecorator<T> {
    private let instance: T
    
    public init(_ instance: T) {
        self.instance = instance
    }
    
    internal func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else { return DispatchQueue.main.async(execute: completion) }
        completion()
    }
}

extension MainDispatchQueueDecorator: AddAccount where T:  AddAccount {
    public func add(
        addAccountModel: AddAccountModel,
        completion: @escaping (AddAccount.Result) -> Void
    ) {
        instance.add(addAccountModel: addAccountModel) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainDispatchQueueDecorator: Authentication where T:  Authentication {
    public func auth(
        authenticationModel: AuthenticationModel,
        completion: @escaping (Authentication.Result) -> Void
    ) {
        instance.auth(authenticationModel: authenticationModel) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
