//
//  CustomButton.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 27.04.26.
//

//import UIKit
//
//final class CustomButton: UIButton {
//    
//    enum ButtonTypes {
//        case text
//        case filled
//    }
//    
//    //MARK: - Properties
//    
//    private let text: String
//    
//    //MARK: - Methods
//    
//    init(text: String, buttonType: ButtonTypes = .filled) {
//        self.text = text
//        super.init(frame: .zero)
//        setTitle(text, for: .normal)
//        
//        titleLabel?.font =  UIFont.systemFont(ofSize: 14, weight: .semibold)
//        
//        
//        switch buttonType {
//        case .filled:
//            backgroundColor = .colorPrimary
//            layer.cornerRadius = 15
//            heightAnchor.constraint(equalToConstant: 48).isActive = true
////            titleLabel?.font =  UIFont.systemFont(ofSize: 14, weight: .semibold)
//        case .text:
//            setTitleColor(.colorPrimary, for: .normal)
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: - Methods
//    
//    //private func
//    
//}

//
//  CustomButton.swift
//  FinalProject
//
//  Created by Natali Zhgenti on 07.01.26.
//

import UIKit

final class CustomButton: UIButton {
    
    // MARK: - Properties
    
    enum CustomButtonStyle {
        case primary
        case secondary
        case text
        
        var backgroundColor: UIColor? {
            switch self {
            case .primary: return .colorPrimary
            case .secondary: return .gray100
            case .text: return nil
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .primary: return .white
            case .secondary: return .black
            case .text: return .colorPrimary
            }
        }
        
        var borderColor: UIColor? {
            switch self {
            case .primary, .text: return nil
            case .secondary: return .gray100
            }
        }
    }
    
    private let style: CustomButtonStyle
    private var action: (() -> Void)?
    private let title: String
    private let image: UIImage?
    
    // MARK: - Init
    
    init(title: String, style: CustomButtonStyle, image: UIImage? = nil) {
        self.title = title
        self.style = style
        self.image = image
        super.init(frame: .zero)
        configure()
        addAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func configure() {
        if style == .text {
            let attributedString = NSAttributedString(
                string: title,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                    .foregroundColor: UIColor.colorPrimary,
                ]
            )
            setAttributedTitle(attributedString, for: .normal)
            return
        }
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = style.backgroundColor
        config.background.cornerRadius = 15
        if let border = style.borderColor {
            config.background.strokeColor = border
            config.background.strokeWidth = 1
        }
        let attributedString = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                .foregroundColor: style.titleColor,
            ]
        )
        if let image {
            config.image = image
            config.imagePlacement = .leading
            config.imagePadding = 16
        }
        setAttributedTitle(attributedString, for: .normal)
        configuration = config
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    func setAction(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    private func addAction() {
        addAction( UIAction { [weak self] _ in
            self?.action?()
        }, for: .touchUpInside)
    }
    
    func updateTitle(_ title: String) {
        setAttributedTitle(
            NSAttributedString(
                string: title,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                    .foregroundColor: style.titleColor,
                ]
            ), for: .normal)
    }
}
