import Lib
import UIKit

public class MainViewController: UITabBarController, UITabBarControllerDelegate, CentralDataProvider {
    @IBOutlet
    public var centralViewModel: CentralViewModel!
    @IBOutlet
    private var viewModel: MainViewModel!

    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogout(_:)), name: .didLogout, object: nil)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notification: NSNotification.Name = viewModel.isLogged ? .didLogin : .didLogout
        let info = viewModel.isLogged ? ["success": true] : nil
        NotificationCenter.default.post(name: notification, object: self, userInfo: info)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    public override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        retrieveTraitCollection()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        setup(viewController: segue.destination)
    }

    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        setup(viewController: viewController)
        return true
    }

    @objc
    private func onDidLogout(_ notification: Notification) {
        performSegue(withIdentifier: "login", sender: self)
    }
}
