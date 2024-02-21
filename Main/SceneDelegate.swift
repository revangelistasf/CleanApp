import UIKit
import UIMobile

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let addAccount = makeRemoteAuthentication(httpClient: makeAlamofireAdapter()) //makeRemoteAddAccount(httpClient: makeAlamofireAdapter())
        let rootController = makeLoginController(authentication: addAccount) //makeSignUpController(addAccount: addAccount)
        let navController = NavigationController(rootViewController: rootController)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
