import Lib
import UIKit

public class ProxyViewController: UINavigationController, UINavigationControllerDelegate, CentralDataProvider {
    public var centralViewModel: CentralViewModel!

    public override func viewDidLoad() {
        delegate = self

        for vc in viewControllers {
            setup(viewController: vc)
        }
    }

    public override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        retrieveTraitCollection()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setup(viewController: segue.destination)
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        setup(viewController: viewController)
    }
}
