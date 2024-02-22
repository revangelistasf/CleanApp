import UIKit
import UIMobile

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navController = NavigationController()
        let addAccount = makeRemoteAddAccount(httpClient: makeAlamofireAdapter())
        let rootController = makeSignUpController(addAccount: addAccount)
        navController.setRootViewController(rootController)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
