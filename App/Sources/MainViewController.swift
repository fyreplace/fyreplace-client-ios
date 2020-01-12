import LibCommon
import RxSwift
import UIKit

class MainViewController: UITabBarController {
    @IBOutlet private var viewModel: MainViewModel!

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogout(_:)), name: .didLogout, object: nil)

        if UserDefaults.standard.string(forKey: "auth:token")?.count ?? 0 == 0 {
            NotificationCenter.default.post(name: .didLogout, object: self)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .didLogout, object: nil)
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

    @objc private func onDidLogout(_ notification: Notification) {
        performSegue(withIdentifier: "login", sender: self)
    }
}
