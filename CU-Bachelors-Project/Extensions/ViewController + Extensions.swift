import UIKit
import SwiftUI

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
        view.backgroundColor = .white
    }
    
    
    //    func showSwiftUIBanner(message: String, isError: Bool = false, duration: TimeInterval = 2.0, completion: (() -> Void)? = nil) {
    //        DispatchQueue.main.async { [weak self] in
    //            guard let self = self else { return }
    //
    //            let bannerMessage = BannerMessage(text: message, isError: isError)
    //            let bannerView = TopBannerView(message: bannerMessage)
    //
    //            let hostingController = UIHostingController(rootView: bannerView)
    //
    //            self.addChild(hostingController)
    //            hostingController.view.backgroundColor = .clear
    //            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    //            view.addSubview(hostingController.view)
    //            hostingController.didMove(toParent: self)
    //
    //            NSLayoutConstraint.activate([
    //                hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
    //                hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    //                hostingController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
    //            ])
    //
    //            hostingController.view.alpha = 0
    //            hostingController.view.transform = CGAffineTransform(translationX: 0, y: -20)
    //
    //            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .beginFromCurrentState, animations: {
    //                hostingController.view.alpha = 1
    //                hostingController.view.transform = .identity
    //            })
    //
    //            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [ weak hostingController] in
    //                guard let hostingController = hostingController else { return }
    //
    //                UIView.animate(withDuration: 0.3, animations: {
    //                    hostingController.view.alpha = 0
    //                    hostingController.view.transform = CGAffineTransform(translationX: 0, y: -20)
    //                }) { _ in
    //                    hostingController.willMove(toParent: nil)
    //                    hostingController.view.removeFromSuperview()
    //                    hostingController.removeFromParent()
    //                    completion?()
    //                }
    //            }
    //        }
    //    }
}
