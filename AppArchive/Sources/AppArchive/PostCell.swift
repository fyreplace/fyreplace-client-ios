import LibItemsList
import LibUtils
import LibWildFyre
import RxSwift
import SDWebImage
import UIKit

public class PostCell: ItemCell<Post, PostCell>, ItemCellDelegate {
    public typealias Item = Post

    @IBOutlet
    private var content: UILabel!
    @IBOutlet
    private var cover: UIImageView!
    @IBOutlet
    private var date: UILabel!
    @IBOutlet
    private var time: UILabel!
    @IBOutlet
    private var author: UILabel!
    @IBOutlet
    private var avatar: UIImageView!
    @IBOutlet
    private var loader: UIActivityIndicatorView!

    public override func awakeFromNib() {
        super.awakeFromNib()
        cover.sd_imageTransition = .fade
        avatar.sd_imageTransition = .fade
    }

    public override func failure(_ error: Error) {
        super.failure(error)
        loader.stopAnimating()
    }

    public func reset() {
        content.text = nil
        cover.image = nil
        date.text = nil
        time.text = nil
        author.text = nil
        avatar.image = nil
        loader.startAnimating()
    }

    public func display(_ item: Post) {
        loader.stopAnimating()

        if let image = item.image {
            cover.sd_setImage(with: URL(string: image)!)
        } else {
            content.text = item.text
        }

        date.text = self.dateFormatter.string(from: item.created)
        time.text = self.timeFormatter.string(from: item.created)
        author.text = item.author?.name

        if let image = item.author?.avatar {
            avatar.sd_setImage(with: URL(string: image)!)
        } else {
            avatar.image = item.author != nil ? #imageLiteral(resourceName: "Avatar") : nil
        }
    }
}
