import UIKit

extension UIViewController {
    func setCustomBackButton(with title: String = "", action: @escaping (() -> Void)) {
        setTitle(title)
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addAction( UIAction { _ in
            action()
        }, for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setTitle(_ title: String) {
        let titleLabel = CustomLabel(
            text: title,
            color: .black,
            font: .systemFont(ofSize: 22, weight: .bold)
        )
        navigationItem.titleView = titleLabel
    }
    
    func setCustomBackground() {
        view.backgroundColor = .systemBackground
    }
}

extension Notification.Name {
    static let colorSchemeDidChange = Notification.Name("colorSchemeDidChange")
}
