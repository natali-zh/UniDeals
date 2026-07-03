import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator : AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let coordinator = AppCoordinator(window: window)
        self.appCoordinator = coordinator
        coordinator.start()
        self.window = window
        applyStoredColorScheme()
        NotificationCenter.default.addObserver(self, selector: #selector(colorSchemeChanged), name: .colorSchemeDidChange, object: nil)
    }

    @objc private func colorSchemeChanged() {
        applyStoredColorScheme()
    }

    private func applyStoredColorScheme() {
        let raw = UserDefaults.standard.string(forKey: "appColorScheme") ?? "system"
        switch raw {
        case "dark":  window?.overrideUserInterfaceStyle = .dark
        case "light": window?.overrideUserInterfaceStyle = .light
        default:      window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        GIDSignIn.sharedInstance.handle(url)
    }
}
