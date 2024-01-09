import Foundation
import Domain

public final class SignUpPresenter {
    private let alertView: AlertView
    private let emailValidator: EmailValidator
    private let addAccount: AddAccount
    private let loadingView: LoadingView

    public init(
        alertView: AlertView,
        emailValidator: EmailValidator,
        addAccount: AddAccount,
        loadingView: LoadingView
    ) {
        self.alertView = alertView
        self.emailValidator = emailValidator
        self.addAccount = addAccount
        self.loadingView = loadingView
    }

    public func signUp(viewModel: SignUpViewModel) {
        if let message = validate(viewModel: viewModel) {
            alertView.showMessage(
                viewModel: AlertViewModel(title: "Validation Failed", message: message)
            )
        } else {
            let addAccountModel = AddAccountModel(
                name: viewModel.name ?? "",
                email: viewModel.email ?? "",
                password: viewModel.password ?? "",
                passwordConfirmation: viewModel.passwordConfirmation ?? ""
            )
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            addAccount.add(addAccountModel: addAccountModel) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    break
                case .failure:
                    self.alertView.showMessage(
                        viewModel: AlertViewModel(title: "Error", message: "Something went wrong, try again later.")
                    )
                }
            }
        }
    }

    private func validate(viewModel: SignUpViewModel) -> String? {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            return "The field name is mandatory"
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "The field email is mandatory"
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "The field password is mandatory"
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return "The field confirm password is mandatory"
        } else if viewModel.password != viewModel.passwordConfirmation {
            return "Please enter a valid confirm password field"
        } else if !emailValidator.isValid(email: viewModel.email ?? "") {
            return "Please enter a valid email field"
        }
        return nil
    }
}

public struct SignUpViewModel {
    public var name: String?
    public var email: String?
    public var password: String?
    public var passwordConfirmation: String?

    public init(
        name: String? = nil,
        email: String? = nil,
        password: String? = nil,
        passwordConfirmation: String? = nil
    ) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
