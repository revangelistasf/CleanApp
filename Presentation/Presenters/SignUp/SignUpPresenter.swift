import Foundation
import Domain

public final class SignUpPresenter {
    private let alertView: AlertView
    private let addAccount: AddAccount
    private let loadingView: LoadingView
    private let validation: Validation
    
    public init(
        alertView: AlertView,
        addAccount: AddAccount,
        loadingView: LoadingView,
        validation: Validation
    ) {
        self.alertView = alertView
        self.addAccount = addAccount
        self.loadingView = loadingView
        self.validation = validation
    }
    
    public func signUp(requestModel: SignUpRequestModel) {
        if let message = validation.validate(data: requestModel.toJson()) {
            showAlert(title: "Validation Failed", message: message)
        } else {
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            addAccount.add(addAccountModel: requestModel.toAddAccountModel()) { [weak self] result in
                guard let self else { return }
                self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
                switch result {
                case .success:
                    showAlert(title: "Success", message: "Account created successfully.")
                case .failure(let error):
                    switch error {
                    case .emailInUse:
                        self.showAlert(message: "This email is already in use.")
                    default:
                        self.showAlert(message: "Something went wrong, try again later.")
                    }
                }
            }
        }
    }
    
    private func showAlert(title: String = "Error", message: String) {
        alertView.showMessage(viewModel: AlertViewModel(title: title, message: message))
    }
}
