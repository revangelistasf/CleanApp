import Foundation

public final class LoginPresenter {
    private let validation: Validation
    
    public init(validation: Validation) {
        self.validation = validation
    }
    
    public func login(_ viewModel: LoginViewModel) {
        _ = validation.validate(data: viewModel.toJson())
    }
}
