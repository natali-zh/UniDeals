import UIKit

final class LoginViewController: BaseViewController {

    // MARK: - Properties

    private let viewModel: LoginViewModel

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "AppLogo"))
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 22
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: 80),
            iv.heightAnchor.constraint(equalToConstant: 80)
        ])
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "UniDeals"
        l.textColor = .gray900
        l.font = .systemFont(ofSize: 26, weight: .bold)
        l.textAlignment = .center
        return l
    }()

    private let emailField = TextFieldWithError(
        labelText: "ელფოსტა",
        textField: CustomTextField(
            placeholder: "შეიყვანეთ ელფოსტა",
            type: .normal(icon: "envelope.fill")
        )
    )

    private let passwordField = TextFieldWithError(
        labelText: "პაროლი",
        textField: CustomTextField(
            placeholder: "შეიყვანეთ პაროლი",
            type: .password
        )
    )

    private let forgotPasswordButton = CustomButton(title: "დაგავიწყდათ პაროლი?", style: .text)
    private let forgotPasswordContainer = UIView()

    private lazy var forgotPasswordStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [forgotPasswordContainer, forgotPasswordButton])
        sv.axis = .horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let signInButton = CustomButton(title: "შესვლა", style: .primary)

    private lazy var orHorizontalStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private lazy var leftLine = makeLine()
    private let orLabel = CustomLabel(text: "ან", color: .gray500, font: .systemFont(ofSize: 12, weight: .medium))
    private lazy var rightLine = makeLine()

    private let googleButton = CustomButton(title: "Google-ით გაგრძელება", style: .secondary, image: UIImage(named: "Google"))

    private let signUpLabel = CustomLabel(text: "არ გაქვთ ანგარიში?", color: .gray500, font: .systemFont(ofSize: 12, weight: .medium))
    private let signUpButton = CustomButton(title: "რეგისტრაცია", style: .text)
    private lazy var signUpStackContainer = CustomStackContainer(label: signUpLabel, button: signUpButton)

    // MARK: - Init

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        addActionsToButtons()
    }

    // MARK: - Setup

    private func setupUI() {
        setCustomBackground()
        setupScrollView()
        configureKeyboardScrollView()
        configureMainStackSubviews()
        configureHorizontalStackSubviews()
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

    private func configureKeyboardScrollView() {
        keyboardScrollView = scrollView
    }

    private func configureMainStackSubviews() {
        let logoWrapper = UIView()
        logoWrapper.translatesAutoresizingMaskIntoConstraints = false
        logoWrapper.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: logoWrapper.topAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: logoWrapper.bottomAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: logoWrapper.centerXAnchor)
        ])

        mainStackView.addArrangedSubview(logoWrapper)
        mainStackView.setCustomSpacing(16, after: logoWrapper)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.setCustomSpacing(40, after: titleLabel)

        mainStackView.addArrangedSubview(emailField)
        mainStackView.addArrangedSubview(passwordField)
        mainStackView.setCustomSpacing(8, after: passwordField)

        mainStackView.addArrangedSubview(forgotPasswordStack)
        mainStackView.setCustomSpacing(16, after: forgotPasswordStack)

        mainStackView.addArrangedSubview(signInButton)
        mainStackView.setCustomSpacing(24, after: signInButton)

        mainStackView.addArrangedSubview(orHorizontalStack)
        mainStackView.setCustomSpacing(24, after: orHorizontalStack)

        mainStackView.addArrangedSubview(googleButton)
        mainStackView.addArrangedSubview(UIView())

        mainStackView.addArrangedSubview(signUpStackContainer)
    }

    private func configureHorizontalStackSubviews() {
        orHorizontalStack.addArrangedSubview(leftLine)
        orHorizontalStack.addArrangedSubview(orLabel)
        orHorizontalStack.addArrangedSubview(rightLine)
        leftLine.widthAnchor.constraint(equalTo: rightLine.widthAnchor).isActive = true
    }

    // MARK: - Bindings

    private func bindViewModel() {
        viewModel.onValidationError = { [weak self] errors in
            guard let self else { return }
            for error in errors {
                switch error.field {
                case .email: emailField.showError(error.message)
                case .password: passwordField.showError(error.message)
                default: break
                }
            }
        }

        viewModel.onAuthenticationError = { [weak self] error in
            guard let self else { return }
            passwordField.showError(error.message)
        }

        viewModel.onGoogleAuthError = { [weak self] message in
            guard let self else { return }
            let alert = UIAlertController(title: "სტუდენტური ანგარიში არ არის", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "კარგი", style: .default))
            present(alert, animated: true)
        }

        viewModel.onLoading = { [weak self] isLoading in
            guard let self else { return }
            DispatchQueue.main.async {
                isLoading ? self.showLoader() : self.hideLoader()
            }
        }
    }

    // MARK: - Actions

    private func addActionsToButtons() {
        addActionToLoginButton()
        addActionToSignUpButton()
        addActionToGoogleButton()
        addActionToForgotPasswordButton()
    }

    private func addActionToLoginButton() {
        signInButton.setAction { [weak self] in
            guard let self, let email = emailField.text, let password = passwordField.text else { return }
            Task { await self.viewModel.logIn(email: email, password: password) }
        }
    }

    private func addActionToSignUpButton() {
        signUpButton.addAction(UIAction { [weak self] _ in
            self?.viewModel.signUpTapped()
        }, for: .touchUpInside)
    }

    private func addActionToGoogleButton() {
        googleButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            Task { await self.viewModel.googleSignInTapped(from: self) }
        }, for: .touchUpInside)
    }

    private func addActionToForgotPasswordButton() {
        forgotPasswordButton.addAction(UIAction { [weak self] _ in
            self?.viewModel.forgotPasswordTapped()
        }, for: .touchUpInside)
    }

    // MARK: - Helpers

    private func makeLine() -> UIView {
        let v = UIView()
        v.backgroundColor = .gray500.withAlphaComponent(0.2)
        v.heightAnchor.constraint(equalToConstant: 1).isActive = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
}
