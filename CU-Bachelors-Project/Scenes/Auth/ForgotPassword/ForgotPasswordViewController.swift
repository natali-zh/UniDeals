import UIKit

final class ForgotPasswordViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: ForgotPasswordViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel = CustomLabel(
        text: "პაროლის აღდგენა",
        color: .gray900,
        font: .systemFont(ofSize: 24, weight: .bold)
    )
    
    private let descriptionLabel = CustomLabel(
        text: "შეიყვანეთ ელფოსტა და გამოგიგზავნით პაროლის აღდგენის ბმულს",
        color: .gray500,
        font: .systemFont(ofSize: 14, weight: .medium)
    )
    
    private let emailField = TextFieldWithError(
        labelText: "ელფოსტა",
        textField: CustomTextField(
            placeholder: "შეიყვანეთ ელფოსტა",
            type: .normal(icon: "envelope.fill")
        )
    )
    
    private let sendButton = CustomButton(title: "ბმულის გაგზავნა", style: .primary)
    
    private let backLabel = CustomLabel(
        text: "გაგახსენდათ პაროლი?",
        color: .gray500,
        font: .systemFont(ofSize: 12, weight: .medium)
    )
    
    private let backButton = CustomButton(title: "შესვლა", style: .text)
    
    private lazy var backStackContainer = CustomStackContainer(label: backLabel, button: backButton)
    
    // MARK: - Init
    
    init(viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        addActionsToButtons()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        setCustomBackground()
        setupScrollView()
        configureKeyboardScrollView()
        configureMainStackSubviews()
    }
    
    private func bindViewModel() {
        viewModel.onValidationError = { [weak self] errors in
            guard let self else { return }
            for error in errors where error.field == .email {
                emailField.showError(error.message)
            }
        }
        
        viewModel.onAuthenticationError = { [weak self] error in
            guard let self else { return }
            emailField.showError(error.message)
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            guard let self else { return }
            DispatchQueue.main.async {
                isLoading ? self.showLoader() : self.hideLoader()
            }
        }

        viewModel.onSuccess = { [weak self] in
            guard let self else { return }
            let alert = UIAlertController(
                title: "შეამოწმე ელფოსტა",
                message: "პაროლის აღდგენის ბმული გამოგზავნილია.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "კარგი", style: .default) { [weak self] _ in
                self?.viewModel.backTapped()
            })
            present(alert, animated: true)
        }
    }
    
    private func addActionsToButtons() {
        sendButton.setAction { [weak self] in
            guard let self, let email = emailField.text else { return }
            Task { await self.viewModel.sendResetLink(email: email) }
        }
        
        backButton.addAction(UIAction { [weak self] _ in
            self?.viewModel.backTapped()
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
            
            mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 18),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            mainStackView.heightAnchor.constraint(
                greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor,
                constant: -18
            )
        ])
    }
    
    private func configureMainStackSubviews() {
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
        mainStackView.setCustomSpacing(50, after: descriptionLabel)
        
        mainStackView.addArrangedSubview(emailField)
        mainStackView.setCustomSpacing(16, after: emailField)
        
        mainStackView.addArrangedSubview(sendButton)
        mainStackView.addArrangedSubview(UIView())
        
        mainStackView.addArrangedSubview(backStackContainer)
    }
    
    private func configureKeyboardScrollView() {
        keyboardScrollView = scrollView
    }
}
