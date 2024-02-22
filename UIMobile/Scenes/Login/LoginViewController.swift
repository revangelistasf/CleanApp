import UIKit
import Presentation

public final class LoginViewController: UIViewController, Storyboarded {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    public var login: ((LoginRequest) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        title = "4Dev"
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loadingIndicator.hidesWhenStopped = true
        hideKeyboardOnTap()
    }
    
    @objc private func didTapLoginButton() {
        let loginRequest = LoginRequest(
            email: emailTextField.text,
            password: passwordTextField.text
        )
        login?(loginRequest)
    }
}

extension LoginViewController: LoadingView {
    public func display(viewModel:  LoadingViewModel) {
        viewModel.isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        view.isUserInteractionEnabled = !viewModel.isLoading
    }
}


extension LoginViewController: AlertView {
    public func showMessage(viewModel: Presentation.AlertViewModel) {
        let alert = UIAlertController(
            title: viewModel.title,
            message: viewModel.message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
