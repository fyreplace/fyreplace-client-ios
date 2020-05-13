import LibWildFyre
import UIKit

public protocol FailureHandler: AnyObject {
    func failure(_ error: Error)
}

extension UIViewController: FailureHandler {
    @objc
    open func failure(_ error: Error) {
        print(error.message)
    }
}
