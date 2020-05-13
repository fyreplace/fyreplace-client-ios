import Foundation
import RxSwift

public protocol ItemsListDataSource: NSObjectProtocol {
    func fetch(from position: Int, size: Int) -> Observable<ItemBucket>
}

public struct ItemBucket {
    public let items: [Decodable]
    public let total: Int

    public init(_ items: [Decodable], total: Int) {
        self.items = items
        self.total = total
    }
}
