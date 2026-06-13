////
////  CustomTextFieldView.swift
////  CU-Bachelors-Project
////
////  Created by Natali Zhgenti on 27.04.26.
////
//
//import UIKit
//
//final class CustomTextFieldView: UIStackView {
//    
//    //MARK: - Properties
//    
//    private let labelText: String
//    private let placeholderText: String
//    
//    
//    private lazy var label: UILabel = {
//        let label = UILabel()
//        label.textColor = .gray700
//        label.font = .systemFont(ofSize: 12, weight: .semibold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private lazy var textField: UITextField = {
//        let textField = UITextField()
//        textField.layer.cornerRadius = 15
//        textField.backgroundColor = .gray100
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true
//        
//        textField.attributedPlaceholder = NSAttributedString(
//            string: placeholderText,
//            attributes: [
//                .foregroundColor: UIColor.gray500,
//                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
//            ]
//        )
//        return textField
//    }()
//    
//    private let icon: UIImageView = {
//        let imageView = UIImageView(image: UIImage(systemName: "envelope"))
//        imageView.contentMode = .scaleAspectFit
//        imageView.tintColor = .gray500
//        // imageView.backgroundColor = .red
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    private let iconContainer = UIView()
//    
//    //MARK: - Init
//    
//    init(labelText: String, placeholderText: String, isSecureEntry: Bool = false) {
//        self.labelText = labelText
//        self.placeholderText = placeholderText
//        super.init(frame: .zero)
//        
//        label.text = labelText
//        
//        setupUI()
//        
//        if isSecureEntry {
//            setupEyeButton()
//        }
//    }
//    
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: - Methods
//    
//    private func setupUI() {
//        addArrangedSubview(label)
//        addArrangedSubview(textField)
//        self.axis = .vertical
//        self.spacing = 8
//        
//        configureIcon()
//    }
//    
//    private func configureIcon() {
//        //iconContainer.backgroundColor = .green
//        textField.leftView = iconContainer
//        textField.leftViewMode = .always
//        
//        iconContainer.addSubview(icon)
//        NSLayoutConstraint.activate([
//            icon.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor, constant: 16),
//            icon.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
//            
//            icon.widthAnchor.constraint(equalToConstant: 18),
//            icon.heightAnchor.constraint(equalToConstant: 18),
//            
//            iconContainer.widthAnchor.constraint(equalToConstant: 44)
//        ])
//    }
//    
//    private lazy var eyeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
//        button.tintColor = .gray500
//        // button.backgroundColor = .green
//        button.imageView?.contentMode = .scaleAspectFit
//        button.addAction(
//            UIAction { [weak self] _ in
//                self?.togglePasswordVisibility()
//            }, for: .touchUpInside
//        )
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    private func setupEyeButton() {
//        let eyeContainer = UIView()
//        addSubview(eyeContainer)
//        eyeContainer.addSubview(eyeButton)
//        
//        NSLayoutConstraint.activate([
//            eyeContainer.widthAnchor.constraint(equalToConstant: 50),
//            eyeButton.centerXAnchor.constraint(equalTo: eyeContainer.centerXAnchor),
//            eyeButton.centerYAnchor.constraint(equalTo: eyeContainer.centerYAnchor),
//            
//            eyeButton.heightAnchor.constraint(equalToConstant: 18),
//            
//            eyeButton.widthAnchor.constraint(equalToConstant: 18)
//        ])
//        textField.rightView = eyeContainer
//        textField.rightViewMode = .always
//    }
//    
//    private func togglePasswordVisibility() {
//        textField.isSecureTextEntry.toggle()
//        let imageName = textField.isSecureTextEntry ? "eye.slash" : "eye"
//        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
//    }
//}
