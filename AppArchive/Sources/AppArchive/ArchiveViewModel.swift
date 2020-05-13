import LibItemsList
import LibWildFyre
import RxSwift

public class ArchiveViewModel: ItemsListViewModel {
    public var ownPosts: Bool {
        get { archiveDataSource.ownPosts }
        set { archiveDataSource.ownPosts = newValue }
    }

    @IBOutlet
    private var archiveDataSource: ArchiveDataSource!

    public override func awakeFromNib() {
        dataSource = archiveDataSource
    }

    public func retrieve(postAt index: Int) -> Observable<Post>? {
        retrieve(itemAt: index)?.map { $0 as! Post }
    }
}
