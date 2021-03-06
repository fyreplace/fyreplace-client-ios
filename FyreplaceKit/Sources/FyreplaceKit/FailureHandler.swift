import UIKit
import WildFyreKit

@objc
public protocol FailureHandler {
    func failure(_ error: Error)
}

extension UIViewController: FailureHandler {
    @objc
    open func failure(_ error: Error) {
        print(error.message)
    }
}
