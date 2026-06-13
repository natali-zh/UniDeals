//
//  CustomTextField.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 13.06.26.
//

import UIKit

enum TextFieldType {
    case normal(icon: String)
    case password
}

final class CustomTextField: TextFieldWithPadding {
    
    // MARK: - Private Properties
    
    private let type: TextFieldType
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray.withAlphaComponent(0.8)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let iconContainer = UIView()
    
    private lazy var eyeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .gray.withAlphaComponent(0.8)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] _ in
            self?.togglePasswordVisibility()
        }, for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    init(placeholder: String,type: TextFieldType) {
        self.type = type
        super.init(frame: .zero)
        
        setupBaseAppearance()
        configurePlaceholder(placeholder)
        configureLeftIcon()
        configureType()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Extensions

private extension CustomTextField {
    
    func setupBaseAppearance() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        layer.cornerRadius = 15
        backgroundColor = .gray100
    }
    
    func configurePlaceholder(_ text: String) {
        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.gray500,
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ]
        )
    }
    
    func configureType() {
        switch type {
        case .normal(let icon):
            iconImageView.image = UIImage(systemName: icon)
            
        case .password:
            iconImageView.image = UIImage(systemName: "lock.fill")
            isSecureTextEntry = true
            textContentType = .password
            configureEyeButton()
        }
    }
    
    func configureLeftIcon() {
        leftView = iconContainer
        leftViewMode = .always
        
        iconContainer.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 45),
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
            
        ])
    }
    
    func configureEyeButton() {
        let eyeContainer = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 48))
        eyeButton.translatesAutoresizingMaskIntoConstraints = true
        eyeButton.frame = CGRect(x: 13, y: 12, width: 24, height: 24)
        eyeContainer.addSubview(eyeButton)
        rightView = eyeContainer
        rightViewMode = .always
    }
    
    
    func togglePasswordVisibility() {
        isSecureTextEntry.toggle()
        let imageName = isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        
    }
}
