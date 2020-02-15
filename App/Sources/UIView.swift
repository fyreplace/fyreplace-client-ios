import UIKit

public extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }

        set {
            let eraseBorder = newValue == nil
            layer.borderColor = newValue?.cgColor
            layer.borderWidth = eraseBorder ? 0 : 1
            layer.cornerRadius = eraseBorder ? 0 : 4
        }
    }
}
