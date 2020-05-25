import FyreplaceKit
import ItemsListKit
import RxSwift
import UIKit

public class ArchiveViewController: ItemsListViewController {
    public override class var emptyMessageText: String { "ArchivePage.ArchiveViewController.empty" }

    private var disposer = DisposeBag()

    @IBOutlet
    private var areaSelector: AreaSelector!
    @IBOutlet
    private var viewModel: ArchiveViewModel!
    @IBOutlet
    private var listTypeChooser: UISegmentedControl!

    public override func viewDidLoad() {
        super.viewDidLoad()
        itemsListViewModel = viewModel
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        areaSelector.createAreaPicker(inside: view)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        areaSelector.destroyAreaPicker()
        disposer = DisposeBag()
    }

    @IBAction
    private func didClickArea() {
        areaSelector.toggleAreaPicker()
    }

    @IBAction
    private func didChangeListType() {
        viewModel.ownPosts = listTypeChooser.selectedSegmentIndex > 0
        refresh()
    }
}

extension ArchiveViewController {
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostCell
        cell.willAppear(with: viewModel.retrieve(postAt: indexPath.row))
        return cell
    }

    public override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = (tableView.cellForRow(at: indexPath) as? PostCell)
        let path = super.tableView(tableView, willSelectRowAt: indexPath)
        return cell?.ready == true ? path : nil
    }
}
