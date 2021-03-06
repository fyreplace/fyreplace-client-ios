import FyreplaceKit
import UIKit

class MainViewController: UITabBarController, CentralDataProvider {
    @IBOutlet
    private var centralDataViewModel: CentralViewModel!

    public var centralViewModel: CentralViewModel! {
        get { centralDataViewModel }
        set { centralDataViewModel = newValue }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        injectData(into: viewControllers)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogout(_:)), name: .didLogout, object: nil)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let notification: NSNotification.Name = centralViewModel.isLogged ? .didLogin : .didLogout
        let info: [String: Any]? = centralViewModel.isLogged ? [.didLoginSuccessUserInfoKey: true] : nil
        NotificationCenter.default.post(name: notification, object: self, userInfo: info)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    public override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        retrieveTraitCollection()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        injectData(into: segue.destination)
    }

    @objc
    private func onDidLogout(_ notification: Notification) {
        performSegue(withIdentifier: "login", sender: self)
    }
}

extension MainViewController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        injectData(into: viewController)
        return true
    }
}
