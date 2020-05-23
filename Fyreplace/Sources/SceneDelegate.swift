import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder {
    var window: UIWindow?
}

@available(iOS 13.0, *)
extension SceneDelegate: UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window?.tintColor = .systemOrange
    }
}
