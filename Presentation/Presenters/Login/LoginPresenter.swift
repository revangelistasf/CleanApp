import Foundation
import Domain

public final class LoginPresenter {
    private let authentication: Authentication
    private let alertView: AlertView
    private let loadingView: LoadingView
    private let validation: Validation
    
    public init(
        authentication: Authentication,
        alertView: AlertView,
        loadingView: LoadingView,
        validation: Validation
    ) {
        self.authentication = authentication
        self.alertView = alertView
        self.loadingView = loadingView
        self.validation = validation
    }
    
    public func login(viewModel: LoginRequest) {
        if let errorMessage = validation.validate(data: viewModel.toJson()) {
            showAlert(title: "Validation Failed", message: errorMessage)
        } else {
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            let authenticationModel = viewModel.toAuthenticationModel()
            authentication.auth(authenticationModel: authenticationModel) { [weak self] result in
                guard let self else { return }
                loadingView.display(viewModel: LoadingViewModel(isLoading: false))
                switch result {
                case .success:
                    showAlert(title: "Success", message: "Login successfully.")
                case .failure(let error):
                    switch error {
                    case .sessionExpired:
                        showAlert(message: "Invalid Email/Password combination.")
                    default:
                        showAlert(message: "Something went wrong, try again later.")
                    }
                }
            }
        }
    }
    
    private func showAlert(title: String = "Error", message: String) {
        alertView.showMessage(viewModel: AlertViewModel(title: title, message: message))
    }
}
