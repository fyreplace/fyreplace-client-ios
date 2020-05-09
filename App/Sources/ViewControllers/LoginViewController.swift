import Lib
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet
    private var viewModel: LoginViewModel!
    @IBOutlet
    private var username: UITextField!
    @IBOutlet
    private var password: UITextField!
    @IBOutlet
    private var buttons: UIStackView!
    @IBOutlet
    private var loader: UIActivityIndicatorView!

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogin(_:)), name: .didLogin, object: nil)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    private func didClickRegister() {
        guard let url = Bundle.main.infoDictionary!["WildFyreRegisterUrl"] as? String else { return }
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }

    @IBAction
    private func didClickLogin() {
        buttons.isHidden = true
        loader.startAnimating()
        view.endEditing(false)
        viewModel.login(username: username.text ?? "", password: password.text ?? "")
    }

    @objc
    private func onDidLogin(_ notification: Notification) {
        guard let success = notification.userInfo?[String.didLoginSuccessUserInfoKey] as? Bool else { return }

        DispatchQueue.main.async {
            self.loader.stopAnimating()
            self.buttons.isHidden = false

            if success {
                self.dismiss(animated: true)
            } else {
                let alert = UIAlertController(
                    title: NSLocalizedString("App.LoginViewController.loginError.title", comment: ""),
                    message: NSLocalizedString("App.LoginViewController.loginError.message", comment: ""),
                    preferredStyle: .alert
                )
                let ok = UIAlertAction(
                    title: NSLocalizedString("App.LoginViewController.loginError.ok", comment: ""),
                    style: .default
                )
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
        }
    }
}
