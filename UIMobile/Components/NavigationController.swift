import UIKit

public final class NavigationController: UINavigationController {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    private func setup() {
        navigationBar.backgroundColor = Color.primaryDark
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .black
    }
    
    public func setRootViewController(_ viewController: UIViewController) {
        setViewControllers([viewController], animated: true)
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = backButton
    }
    
    public func pushViewController(_ viewController: UIViewController) {
        pushViewController(viewController, animated: true)
    }
}
