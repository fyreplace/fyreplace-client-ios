import RxSwift
import UIKit

open class ItemsListViewModel: NSObject {
    private static let cacheSize: UInt = .pageSize * 10

    public var dataSource: ItemsListDataSource!
    public lazy var count: Observable<UInt> = mFutureCount.merge()

    private var mFutureCount = PublishSubject<Observable<UInt>>()
    private var mFutureCachedPages: [UInt: ReplaySubject<Observable<[Decodable]>>] = [:]
    private var cachedPages: [UInt: Observable<[Decodable]>] = [:]
    private var pagesToFetch: [UInt] = []
    private var isFetching = false

    public func retrieve(itemAt index: UInt) -> Observable<Decodable>? {
        let page = index.page

        if cachedPages[page] == nil {
            mFutureCachedPages[page] = .create(bufferSize: 1)
            cachedPages[page] = mFutureCachedPages[page]?.merge().share(replay: 1)
            pagesToFetch.append(page)
            fetchIfNeeded()
        }

        let pageIndex = Int(index % .pageSize)
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

        if UInt(mFutureCachedPages.count) * .pageSize > ItemsListViewModel.cacheSize {
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

private extension UInt {
    static let pageSize: UInt = (UIDevice.current.userInterfaceIdiom == .phone ? 8 : 12)
    var page: UInt { self / .pageSize }
}
