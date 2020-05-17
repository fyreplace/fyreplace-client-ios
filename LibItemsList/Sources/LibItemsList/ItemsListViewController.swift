import Lib
import LibUtils
import RxSwift
import UIKit

open class ItemsListViewController: UITableViewController {
    open class var emptyMessageText: String { "LibItemsList.ItemsListViewController.empty" }

    public var itemsListViewModel: ItemsListViewModel!
    private var count = 0
    private var disposer = DisposeBag()

    open override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        updateBackground(allowMessage: true)
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidRefresh), name: .didChangeArea, object: nil)
        refreshControl?.addTarget(self, action: #selector(onDidRefresh), for: .valueChanged)

        itemsListViewModel.count
            .purify(with: self)
            .subscribe(onNext: { self.count = $0 })
            .disposed(by: disposer)

        refresh()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        refreshControl?.removeTarget(self, action: nil, for: .valueChanged)
        disposer = DisposeBag()
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        itemsListViewModel.clear()
    }

    public func refresh() {
        count = 0
        updateBackground(allowMessage: false)
        tableView.reloadData()

        let disposer = CompositeDisposable()
        itemsListViewModel.start()?
            .purify(with: self)
            .subscribe(onNext: {
                self.updateBackground(allowMessage: true)
                self.refreshControl?.endRefreshing()
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                disposer.dispose()
            })
            .disposed(by: disposer)
    }

    private func updateBackground(allowMessage: Bool) {
        guard allowMessage, count == 0 else {
            tableView.backgroundView = nil
            return
        }

        let emptyMessage = UILabel()
        emptyMessage.font = .preferredFont(forTextStyle: .headline)
        emptyMessage.textAlignment = .center
        emptyMessage.text = .tr(Self.emptyMessageText)
        tableView.backgroundView = emptyMessage
    }

    @objc
    private func onDidRefresh() {
        refresh()
    }
}

extension ItemsListViewController {
    open override func failure(_ error: Error) {
        super.failure(error)
        tableView.refreshControl?.endRefreshing()
    }
}

extension ItemsListViewController {
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        count
    }
}

extension ItemsListViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for path in indexPaths {
            itemsListViewModel.retrieve(itemAt: path.row)?
                .subscribe()
                .disposed(by: disposer)
        }
    }
}
