import Lib
import LibUtils
import UIKit

public class ProxyViewController: UINavigationController, UINavigationControllerDelegate, CentralDataProvider {
    public var centralViewModel: CentralViewModel!

    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        injectData(into: viewControllers)
    }

    public override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        retrieveTraitCollection()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        injectData(into: segue.destination)
        super.prepare(for: segue, sender: sender)
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        injectData(into: viewController)
        super.pushViewController(viewController, animated: animated)
    }

    public override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        injectData(into: viewControllers)
        super.setViewControllers(viewControllers, animated: animated)
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        injectData(into: viewController)
    }
}
