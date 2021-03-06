import Foundation
import RxSwift
import WildFyreKit

public class PostRepository: NSObject {
    @IBOutlet
    private var areaRepo: AreaRepository!

    private let provider = BaseProvider<PostTarget>()

    public func getArchive(from position: Int, size: Int) -> Observable<SuperPost> {
        provider.req(.archive(areaName: areaRepo.currentArea ?? "", offset: position, limit: size), as: SuperPost.self)
    }

    public func getOwnPosts(from position: Int, size: Int) -> Observable<SuperPost> {
        provider.req(.own(areaName: areaRepo.currentArea ?? "", offset: position, limit: size), as: SuperPost.self)
    }

    public func getPost(id: String) -> Observable<Post> {
        provider.req(.get(areaName: areaRepo.currentArea ?? "", postId: id), as: Post.self)
    }
}
