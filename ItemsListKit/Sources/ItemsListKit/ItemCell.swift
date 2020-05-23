import FyreplaceKit
import RxSwift
import UIKit

open class ItemCell<Item, CellDelegate>: UITableViewCell, FailureHandler
where CellDelegate: ItemCellDelegate, Item == CellDelegate.Item {
    public weak var delegate: CellDelegate?
    public let dateFormatter = DateFormatter()
    public let timeFormatter = DateFormatter()
    private var disposer = DisposeBag()

    open override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self as? CellDelegate
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .medium
        timeFormatter.locale = Locale.current
    }

    open func failure(_ error: Error) {}

    public final func willAppear(with item: Observable<Item>?) {
        delegate?.reset()
        disposer = DisposeBag()

        guard let item = item else {
            failure(ItemError.missing)
            return
        }

        item.fail(with: self)
            .subscribe(onNext: { self.delegate?.display($0) })
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
