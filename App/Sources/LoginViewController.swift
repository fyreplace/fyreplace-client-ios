import UIKit

public class LoginViewController: UIViewController {
    @IBOutlet private var viewModel: LoginViewModel!
    @IBOutlet private var username: UITextField!
    @IBOutlet private var password: UITextField!
    @IBOutlet private var login: UIButton!

    override public func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogin(_:)), name: .didLogin, object: nil)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .didLogin, object: nil)
    }

    @IBAction func didSetUsername() {
        password.becomeFirstResponder()
    }

    @IBAction func didSetPassword() {
        view.endEditing(false)
    }

    @IBAction func didClickLogin() {
        if login.isEnabled {
            login.isEnabled = false
            viewModel.login(username: username.text ?? "", password: password.text ?? "")
        }
    }

    @objc private func onDidLogin(_ notification: Notification) {
        guard let success = notification.userInfo?["success"] as? Bool else { return }

        if success {
            dismiss(animated: true)
        } else {
            login.isEnabled = true
        }
    }
}
