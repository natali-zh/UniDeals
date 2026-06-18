import UIKit
//final class TextFieldWithError: UIView {
//    
//    //MARK: - Properties
//    
//    private let label: UILabel
//    private let textField: UITextField
//    private let errorLabel: UILabel
//    
//    var onTextChange: ((String) -> Void)?
//    
//    var text: String? {
//        get { textField.text }
//        set { textField.text = newValue }
//    }
//    
//    //MARK: - Init
//    
//    init(labelText: String, placeholder: String, imageName: String? = nil) {
//        label = CustomLabel(labelText, .gray, labelFont: .systemFont(ofSize: 12, weight: .medium), letterSpacing: 1.1)
//        if let imageName = imageName {
//            textField = CustomTextField(placeholderText: placeholder, imageName: imageName)
//        } else {
//           textField = PasswordTextField(placeholder)
//        }
//        errorLabel = CustomLabel("error", .systemRed, labelFont: .systemFont(ofSize: 12, weight: .medium), letterSpacing: 1.1)
//        super.init(frame: .zero)
//        
//        setup()
//        setupStackView()
//    }
//    
//    required init?(coder: NSCoder) { fatalError() }
//    
//    //MARK: - Methods
//    
//    private func setup() {
//        hideError()
//        addAction()
//    }
//    
//    private func setupStackView() {
//        let stack = UIStackView(arrangedSubviews: [label, textField, errorLabel.makeErrorLabelContainer()])
//        stack.axis = .vertical
//        stack.spacing = 8
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        
//        addSubview(stack)
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: topAnchor),
//            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
//            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
//            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//    }
//    
//    private func addAction() {
//        textField.addAction(
//            UIAction { [weak self] _ in
//                self?.hideError()
//                self?.onTextChange?(self?.textField.text ?? "")
//            }, for: .editingChanged)
//    }
//    
//    func showError(_ message: String) {
//        errorLabel.text = message
//        errorLabel.isHidden = false
//        textField.showError()
//    }
//    
//    private func hideError() {
//        errorLabel.isHidden = true
//        textField.hideError()
//    }
//}

final class TextFieldWithError: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    var text: String? {
        textField.text
    }
    
    var onTextChange: ((String) -> Void)?
    
    init(labelText: String, textField: UITextField) {
        self.textField = textField
        
        super.init(frame: .zero)
        setupUI()
        addTextChangeAction()
        hideError()
        titleLabel.text = labelText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        if let textField = textField as? TextFieldWithPadding {
            textField.showError()
        }

    }

    func hideError() {
        errorLabel.isHidden = true
        if let textField = textField as? TextFieldWithPadding {
            textField.hideError()
        }
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            textField,
            errorLabel.makeErrorLabelContainer()
        ])
        
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addTextChangeAction() {
        textField.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.hideError()
            self.onTextChange?(self.textField.text ?? "")
        }, for: .editingChanged)
    }
}




protocol TextFieldErrorShowable {
    func showError()
    func hideError()
}
