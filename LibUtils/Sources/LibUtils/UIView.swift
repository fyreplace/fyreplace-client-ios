import UIKit

public extension UIView {
    @IBInspectable
    var isRound: Bool {
        get {
            layer.cornerRadius >= frame.width / 2
        }

        set {
            layer.cornerRadius = newValue ? frame.width / 2 : 0
        }
    }
}
