import LibWildFyre
import SDWebImage
import UIKit

public extension UIImageView {
    func setAvatar(_ avatar: String?) {
        if let avatar = avatar {
            if avatar != sd_imageURL?.absoluteString {
                sd_setImage(with: URL(string: avatar))
            }
        } else {
            image = #imageLiteral(resourceName: "Avatar")
        }
    }
}
