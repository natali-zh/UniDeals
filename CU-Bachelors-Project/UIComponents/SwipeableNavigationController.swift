import UIKit

final class SwipeableNavigationController: UINavigationController, UINavigationControllerDelegate {

    var onDidShow: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer?.delegate = nil
    }

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        interactivePopGestureRecognizer?.isEnabled = viewControllers.count > 1
        onDidShow?()
    }
}
