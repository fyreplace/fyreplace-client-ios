import FyreplaceKit
import RxSwift
import UIKit

open class ItemCell<Item, CellDelegate>: UITableViewCell, FailureHandler
where CellDelegate: ItemCellDelegate, Item == CellDelegate.Item {
    public weak var delegate: CellDelegate?
    public let dateFormatter = DateFormatter()
    public let timeFormatter = DateFormatter()

    private(set) public var item: Item?
    private(set) public var ready = false
    private var disposer = DisposeBag()

    open override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self as? CellDelegate
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = .current
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .medium
        timeFormatter.locale = .current
    }

    open func failure(_ error: Error) {
        ready = false
    }

    public final func willAppear(with item: Observable<Item>?) {
        ready = false
        delegate?.reset()
        disposer = DisposeBag()

        guard let item = item else {
            failure(ItemError.missing)
            return
        }

        item.fail(with: self)
            .subscribe(onNext: { [unowned self] item in
                self.delegate?.display(item)
                self.item = item
                self.ready = true
            })
            .disposed(by: disposer)
    }
}

public protocol ItemCellDelegate: AnyObject {
    associatedtype Item: Decodable

    func reset()

    func display(_ item: Item)
}

public enum ItemError: Error {
    case missing
}
