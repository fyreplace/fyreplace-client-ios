import SDWebImage
import UIKit

public extension UIImageView {
    func setAvatar(_ avatar: URL?) {
        if let avatar = avatar {
            if avatar != sd_imageURL {
                sd_setImage(with: avatar)
            }
        } else {
            image = #imageLiteral(resourceName: "Avatar")
        }
    }
}
