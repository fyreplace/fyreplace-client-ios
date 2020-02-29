import Lib
import UIKit

public class LoginViewController: UIViewController {
    @IBOutlet
    private var viewModel: LoginViewModel!
    @IBOutlet
    private var username: UITextField!
    @IBOutlet
    private var password: UITextField!
    @IBOutlet
    private var login: UIButton!

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogin(_:)), name: .didLogin, object: nil)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        view.endEditing(false)
    }

    @IBAction
    private func didSetUsername() {
        password.becomeFirstResponder()
    }

    @IBAction
    private func didSetPassword() {
        view.endEditing(false)
    }

    @IBAction
    private func didClickLogin() {
        if login.isEnabled {
            login.isEnabled = false
            viewModel.login(username: username.text ?? "", password: password.text ?? "")
        }
    }

    @objc
    private func onDidLogin(_ notification: Notification) {
        guard let success = notification.userInfo?["success"] as? Bool else { return }

        DispatchQueue.main.async {
            if success {
                self.dismiss(animated: true)
            } else {
                self.login.isEnabled = true
            }
        }
    }
}
