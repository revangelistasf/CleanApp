import UIKit

public final class WelcomeViewController: UIViewController, Storyboarded {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    public var login: (() -> Void)?
    public var signUp: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = "4Dev"
        loginButton.addTarget(self, action: #selector(didTapOnLogin), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapOnSignUp), for: .touchUpInside)
    }
    
    @objc func didTapOnLogin() {
        login?()
    }
        
    @objc func didTapOnSignUp() {
        signUp?()
    }
    
    @objc func didTapOnCreateAccount() {
        print(#function)
    }
}
