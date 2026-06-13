//
//  SignUpViewController.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 13.06.26.
//

import UIKit

final class SignUpViewController: BaseViewController {
    
    //MARK: - Properties
        
    private let mainStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let fullnameField = TextFieldWithError(
        labelText: "Full Name",
        textField: CustomTextField(
            placeholder: "Your full name",
            type: .normal(icon: "person.text.rectangle.fill"))
    )
    private let usernameField =  TextFieldWithError(
        labelText: "Username",
        textField: CustomTextField(
            placeholder: "Your username",
            type: .normal(icon: "person.fill")
        )
    )
    
    private let emailField = TextFieldWithError(
        labelText: "Student Email",
        textField: CustomTextField(
            placeholder: "Your student email",
            type: .normal(icon: "envelope.fill")
        )
    )
    
    private let passwordField =  TextFieldWithError(
        labelText: "Enter Password",
        textField: CustomTextField(
            placeholder: "Your password",
            type: .password
        )
    )
    
    private let confirmPasswordField = TextFieldWithError(
        labelText:  "Confirm Password",
        textField: CustomTextField(
            placeholder:  "Confirm Password",
            type: .password
        )
    )
    
    private let signUpButton = CustomButton(title: "Create Account", style: .primary)
    
    private let loginLabel = CustomLabel(
        text: "Already have an account?",
        color:  UIColor.gray500,
        font: .systemFont(ofSize: 12, weight: .medium)
    )
    
    private let loginButton = CustomButton(title: "Sign In", style: .text)
    private lazy var loginContainer = CustomStackContainer(label: loginLabel, button: loginButton)
    
    
    //MARK: - Init
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: - Methods
    
    private func setUpUI() {
        setCustomBackground()
        //
        configureMainStackSubviews()
        configureKeyboardScrollView()
        setupScrollView()
    }

    
    private func configureKeyboardScrollView() {
        keyboardScrollView = scrollView
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            
            mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            mainStackView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor, constant: -32)
        ])
    }
    
    private func configureMainStackSubviews() {
        mainStackView.addArrangedSubview(fullnameField)
        mainStackView.addArrangedSubview(usernameField)
        mainStackView.addArrangedSubview(emailField)
        mainStackView.addArrangedSubview(passwordField)
        mainStackView.addArrangedSubview(confirmPasswordField)
        mainStackView.setCustomSpacing(36, after: confirmPasswordField)
        mainStackView.addArrangedSubview(signUpButton)
        mainStackView.addArrangedSubview(UIView())
        mainStackView.addArrangedSubview(loginContainer)
    }
}
