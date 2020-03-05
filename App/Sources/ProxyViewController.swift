import Lib
import UIKit

public class ProxyViewController: UINavigationController, UINavigationControllerDelegate, CentralDataProvider {
    public var centralViewModel: CentralViewModel!

    public override func viewDidLoad() {
        super.viewDidLoad()
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
        super.prepare(for: segue, sender: sender)
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        setup(viewController: viewController)
        super.pushViewController(viewController, animated: animated)
    }

    public override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        for vc in viewControllers {
            setup(viewController: vc)
        }

        super.setViewControllers(viewControllers, animated: animated)
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        setup(viewController: viewController)
    }
}
