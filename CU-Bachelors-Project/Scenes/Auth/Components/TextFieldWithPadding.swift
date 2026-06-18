import UIKit

class TextFieldWithPadding: UITextField, UITextFieldDelegate, TextFieldErrorShowable {
    private let textPadding = UIEdgeInsets(
        top: 8,
        left: 8,
        bottom: 8,
        right: 8
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpReturnKey()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    private func setUpReturnKey() {
        self.delegate = self
        self.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    private let normalBackgroundColor = UIColor.gray100

       private let errorBorderColor = UIColor.systemRed.cgColor

       func showError() {
           layer.borderWidth = 1
           layer.borderColor = errorBorderColor
       }

       func hideError() {
           layer.borderWidth = 0
           layer.borderColor = UIColor.clear.cgColor
       }
}
