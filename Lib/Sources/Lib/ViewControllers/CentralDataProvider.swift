import UIKit

public protocol CentralDataProvider: CentralDataConsumer {
}

public extension CentralDataProvider {
    func injectData(into viewController: UIViewController?) {
        guard let consumer = viewController as? CentralDataConsumer else { return }
        consumer.centralViewModel = centralViewModel
    }

    func injectData(into viewControllers: [UIViewController]?) {
        guard let controllers = viewControllers else { return }

        for controller in controllers {
            injectData(into: controller)
        }
    }
}
