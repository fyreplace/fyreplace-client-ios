import UIKit

public class KeyboardAvoidingConstraint: NSLayoutConstraint {
    private var originalConstant: CGFloat? = nil
    private var keyboardHeight: CGFloat = 0

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardDidShow(_ notification: Notification) {
        let frameValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)
        guard let keyboardSize = frameValue?.cgRectValue.size else { return }
        updateKeyboard(height: keyboardSize.height)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        updateKeyboard(height: 0)
    }

    private func updateKeyboard(height: CGFloat) {
        if originalConstant == nil {
            originalConstant = constant
        }

        keyboardHeight = height
        constant = originalConstant! - keyboardHeight
    }
}
