import UIKit

public protocol CentralDataProvider: CentralDataConsumer {
}

public extension CentralDataProvider {
    func setup(viewController: UIViewController) {
        guard let consumer = viewController as? CentralDataConsumer else { return }
        consumer.centralViewModel = centralViewModel
    }
}
