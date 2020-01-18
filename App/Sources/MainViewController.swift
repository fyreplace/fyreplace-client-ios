import Lib
import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    @IBOutlet private var viewModel: MainViewModel!
    @IBOutlet private var centralViewModel: CentralViewModel!

    override func viewDidLoad() {
        delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogout(_:)), name: .didLogout, object: nil)

        let notification: NSNotification.Name = viewModel.isLogged ? .didLogin : .didLogout
        let info = viewModel.isLogged ? ["success": true] : nil
        NotificationCenter.default.post(name: notification, object: self, userInfo: info)
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        let isPhone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
        let isPortrait = view.bounds.width < view.bounds.height
        let traits = [
            UITraitCollection(horizontalSizeClass: isPhone ? .compact : .regular),
            UITraitCollection(verticalSizeClass: isPortrait ? .regular : .compact)
        ]

        return UITraitCollection(traitsFrom: traits)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setup(viewController: segue.destination)
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        setup(viewController: viewController)
    }

    @objc private func onDidLogout(_ notification: Notification) {
        performSegue(withIdentifier: "login", sender: self)
    }

    private func setup(viewController: UIViewController) {
        if var consumer = viewController as? CentralDataConsumer {
            consumer.centralViewModel = centralViewModel
        }
    }
}
