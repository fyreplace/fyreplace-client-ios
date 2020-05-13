import Lib
import LibItemsList
import LibUtils
import RxSwift
import UIKit

public class ArchiveViewController: ItemsListViewController, AreaSelectorDelegate {
    public override class var emptyMessageText: String { "AppArchive.ArchiveViewController.empty" }

    private var disposer = DisposeBag()

    @IBOutlet
    private var areaSelector: AreaSelector!
    @IBOutlet
    private var viewModel: ArchiveViewModel!
    @IBOutlet
    private var listTypeChooser: UISegmentedControl!

    public override func viewDidLoad() {
        super.viewDidLoad()
        areaSelector.delegate = self
        itemsListViewModel = viewModel
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        areaSelector.createAreaPicker(inside: tableView)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        areaSelector.destroyAreaPicker()
        disposer = DisposeBag()
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostCell
        cell.willAppear(with: viewModel.retrieve(postAt: indexPath.row))
        return cell
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
