import UIKit

open class ImageIconCell: UITableViewCell {
    public override func awakeFromNib() {
        super.awakeFromNib()
        imageView?.layer.masksToBounds = true
        imageView?.layer.cornerRadius = round((imageView?.bounds.width ?? 0) / 6)
    }
}
