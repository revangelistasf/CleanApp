import UIKit
import Presentation

final class SignUpViewController: UIViewController {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SignUpViewController: LoadingView {
    func display(viewModel: Presentation.LoadingViewModel) {
        viewModel.isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
}
