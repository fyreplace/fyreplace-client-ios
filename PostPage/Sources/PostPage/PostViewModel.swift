import FyreplaceKit
import RxSwift
import UIKit
import WildFyreKit

public class PostViewModel: NSObject {
    public lazy var post: Observable<Post> = mFuturePost.merge()
    public lazy var author: Observable<Author?> = post.map { $0.author }

    private let mFuturePost = ReplaySubject<Observable<Post>>.create(bufferSize: 1)

    @IBOutlet
    private var postRepo: PostRepository!

    public func setPost(_ post: Post) {
        mFuturePost.onNext(Observable.of(post))
    }

    public func setPost(id: String) {
        mFuturePost.onNext(postRepo.getPost(id: id))
    }
}
