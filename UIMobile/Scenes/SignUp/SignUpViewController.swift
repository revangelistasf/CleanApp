import UIKit
import Presentation

public final class SignUpViewController: UIViewController, Storyboarded {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    public var signUp: ((SignUpRequestModel) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = "4Dev"
        saveButton.layer.cornerRadius = 5
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        loadingIndicator.hidesWhenStopped = true
        hideKeyboardOnTap()
    }

    @objc private func didTapSaveButton() {
        let signUpViewModel = SignUpRequestModel(
            name: nameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text,
            passwordConfirmation: passwordConfirmationTextField.text
        )
        
        signUp?(signUpViewModel)
    }
}

extension SignUpViewController: LoadingView {
    public func display(viewModel:  LoadingViewModel) {
        viewModel.isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        view.isUserInteractionEnabled = !viewModel.isLoading
    }
}


extension SignUpViewController: AlertView {
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
