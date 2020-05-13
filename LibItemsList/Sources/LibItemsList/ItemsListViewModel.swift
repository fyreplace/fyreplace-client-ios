import RxSwift
import UIKit

open class ItemsListViewModel: NSObject {
    private static let cacheSize: Int = .pageSize * 10

    public var dataSource: ItemsListDataSource!
    public lazy var count: Observable<Int> = mFutureCount.merge()

    private var mFutureCount = PublishSubject<Observable<Int>>()
    private var mFutureCachedPages: [Int: ReplaySubject<Observable<[Decodable]>>] = [:]
    private var cachedPages: [Int: Observable<[Decodable]>] = [:]
    private var pagesToFetch: [Int] = []
    private var isFetching = false

    public func retrieve(itemAt index: Int) -> Observable<Decodable>? {
        let page = index.page

        if cachedPages[page] == nil {
            mFutureCachedPages[page] = .create(bufferSize: 1)
            cachedPages[page] = mFutureCachedPages[page]?.merge().share(replay: 1)
            pagesToFetch.append(page)
            fetchIfNeeded()
        }

        let pageIndex = index % .pageSize
        return cachedPages[page]?
            .filter { $0.count > pageIndex }
            .map { $0[pageIndex] }
    }

    public func start() -> Observable<Void>? {
        clear()
        _ = retrieve(itemAt: 0)
        return cachedPages[0]?.map { _ in Void() }
    }

    public func clear() {
        mFutureCount.onNext(.of(0))
        mFutureCachedPages.removeAll()
        cachedPages.removeAll()
        pagesToFetch.removeAll()
    }

    private func fetchIfNeeded() {
        guard !isFetching, !pagesToFetch.isEmpty else { return }
        isFetching = true

        let page = pagesToFetch.removeLast()
        let bucket = dataSource.fetch(from: page * .pageSize, size: .pageSize).share()

        mFutureCount.onNext(bucket.map { $0.total })
        mFutureCachedPages[page]?.onNext(bucket.map { $0.items })

        if mFutureCachedPages.count * .pageSize > ItemsListViewModel.cacheSize {
            let indexes = mFutureCachedPages.keys.sorted { abs($0.distance(to: page)) > abs($1.distance(to: page)) }
            let index = indexes.first!
            mFutureCachedPages.removeValue(forKey: index)
            cachedPages.removeValue(forKey: index)
            pagesToFetch.removeAll { $0 == index }
        }

        _ = bucket.subscribe(onDisposed: {
            self.isFetching = false
            self.fetchIfNeeded()
        })
    }
}

private extension Int {
    static let pageSize = (UIDevice.current.userInterfaceIdiom == .phone ? 8 : 12)
    var page: Int { self / .pageSize }
}
