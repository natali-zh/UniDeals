//
//  SignUpViewController.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 13.06.26.
//

import UIKit

final class SignUpViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: SignUpViewModel
    
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
    
    private let titleLabel = CustomLabel(
        text: "ანგარიშის შექმნა",
        color: .gray900,
        font: .systemFont(ofSize: 24, weight: .bold)
    )
    
    private let descriptionLabel = CustomLabel(
        text: "შეუერთდი ათასობით სტუდენტს და დაზოგე თანხა",
        color: .gray500,
        font: .systemFont(ofSize: 14, weight: .medium)
    )
    
    private let fullnameField = TextFieldWithError(
        labelText: "სრული სახელი",
        textField: CustomTextField(
            placeholder: "შეიყვანეთ სრული სახელი",
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
        labelText: "სტუდენტური ელფოსტა",
        textField: CustomTextField(
            placeholder: "შეიყვანეთ სტუდენტური ელფოსტა",
            type: .normal(icon: "envelope.fill")
        )
    )
    
    private let passwordField =  TextFieldWithError(
        labelText: "პაროლი",
        textField: CustomTextField(
            placeholder: "შეიყვანეთ პაროლი",
            type: .password
        )
    )
    
    private let confirmPasswordField = TextFieldWithError(
        labelText:  "გაიმეორეთ პაროლი",
        textField: CustomTextField(
            placeholder:  "გაიმეორეთ პაროლი",
            type: .password
        )
    )
    
    private let signUpButton = CustomButton(title: "რეგისტრაცია", style: .primary)
    
    private let loginLabel = CustomLabel(
        text: "უკვე გაქვთ ანგარიში?",
        color:  UIColor.gray500,
        font: .systemFont(ofSize: 12, weight: .medium)
    )
    
    private let loginButton = CustomButton(title: "შესვლა", style: .text)
    private lazy var loginContainer = CustomStackContainer(label: loginLabel, button: loginButton)
    
    
    //MARK: - Init
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
        addActionsToButtons()
    }
    
    // MARK: - Methods
    
    private func setUpUI() {
        setCustomBackground()
        setCustomBackButton { [weak self] in
            guard let self else { return }
            viewModel.onBack?()
        }
        configureMainStackSubviews()
        configureKeyboardScrollView()
        setupScrollView()
    }
    
    private func bindViewModel() {
        viewModel.onValidationError = { [weak self] errors in
            guard let self = self else { return }
            
            for error in errors {
                switch error.field {
                case .fullname:
                    fullnameField.showError(error.message)
                case .username:
                    usernameField.showError(error.message)
                case .email:
                    emailField.showError(error.message)
                case .password:
                    passwordField.showError(error.message)
                case .confirmPassword:
                    confirmPasswordField.showError(error.message)
                }
            }
        }
        
        viewModel.onAuthenticationError = { [weak self] error in
            guard let self = self else { return }
            emailField.showError(error.message)
        }
        
        //        viewModel.onLoading = { [weak self] isLoading in
        //            guard let self = self else { return }
        //            if isLoading {
        //                self.showLoader()
        //            } else {
        //                self.hideLoader()
        //            }
        //        }
    }
    
    
    private func configureKeyboardScrollView() {
        keyboardScrollView = scrollView
    }
    
    private func addActionsToButtons() {
        addActionToSignUp()
        addActionToLogin()
    }
    
    private func addActionToSignUp() {
        signUpButton.addAction( UIAction { [weak self] _ in
            guard let self = self, let fullname = fullnameField.text,
                  let username = usernameField.text,
                  let email = emailField.text,
                  let password = passwordField.text,
                  let confirmPassword = confirmPasswordField.text  else { return }
            Task {
                await self.viewModel.signUp(with: User(fullname: fullname, username: username, email: email), password: password, confirmPassword: confirmPassword)}
        }, for: .touchUpInside)
    }
    
    private func addActionToLogin(){
        loginButton.addAction( UIAction { [weak self] _ in
            guard let self = self else { return }
            viewModel.backButtonTapped()
        }, for: .touchUpInside)
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
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
        mainStackView.setCustomSpacing(36, after: descriptionLabel)
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
