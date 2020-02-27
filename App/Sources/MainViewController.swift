import Lib
import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate, CentralDataProvider {
    @IBOutlet
    public var centralViewModel: CentralViewModel!
    @IBOutlet
    private var viewModel: MainViewModel!

    override func viewDidLoad() {
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogout(_:)), name: .didLogout, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        let notification: NSNotification.Name = viewModel.isLogged ? .didLogin : .didLogout
        let info = viewModel.isLogged ? ["success": true] : nil
        NotificationCenter.default.post(name: notification, object: self, userInfo: info)
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        retrieveTraitCollection()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setup(viewController: segue.destination)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        setup(viewController: viewController)
        return true
    }

    @objc
    private func onDidLogout(_ notification: Notification) {
        performSegue(withIdentifier: "login", sender: self)
    }
}
