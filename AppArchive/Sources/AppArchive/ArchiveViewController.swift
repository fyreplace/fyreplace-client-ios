import Lib
import UIKit

public class ArchiveViewController: UIViewController, AreaSelectorDelegate {
    @IBOutlet
    private var areaSelector: AreaSelector!

    public override func viewDidLoad() {
        areaSelector.delegate = self
    }

    public override func viewWillAppear(_ animated: Bool) {
        areaSelector.createAreaPicker(inside: view)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        areaSelector.destroyAreaPicker()
    }

    @IBAction
    private func didClickArea() {
        areaSelector.toggleAreaPicker()
    }
}
