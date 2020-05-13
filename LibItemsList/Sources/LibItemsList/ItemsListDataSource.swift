import Foundation
import RxSwift

public protocol ItemsListDataSource: NSObjectProtocol {
    func fetch(from position: UInt, size: UInt) -> Observable<ItemBucket>
}

public struct ItemBucket {
    public let items: [Decodable]
    public let total: UInt

    public init(_ items: [Decodable], total: UInt) {
        self.items = items
        self.total = total
    }
}
