import RxSwift
import SDWebImage
import UIKit
import WildFyreKit

public class PostViewController: UIViewController {
    public var post: Post?
    public var postId: String?

    private var disposer = DisposeBag()

    @IBOutlet
    private var viewModel: PostViewModel!
    @IBOutlet
    private var username: UILabel!
    @IBOutlet
    private var avatar: UIImageView!

    public override func viewDidLoad() {
        super.viewDidLoad()

        if let post = post {
            viewModel.setPost(post)
        } else if let postId = postId {
            viewModel.setPost(id: postId)
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.author
            .fail(with: self)
            .subscribe(onNext: { author in
                self.username.text = author?.name
                self.avatar.setAvatar(author?.avatar)
                self.avatar.isHidden = author == nil
            })
            .disposed(by: disposer)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposer = DisposeBag()
    }
}
