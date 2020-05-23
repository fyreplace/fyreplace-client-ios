import UIKit

public class RoundedImageView: UIImageView {
    @IBInspectable
    public var smallRadius: Bool = false { didSet { updateCorners() } }

    public override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        updateCorners()
    }

    private func updateCorners() {
        layer.cornerRadius = smallRadius ? 4 : (bounds.width / 10)
    }
}
