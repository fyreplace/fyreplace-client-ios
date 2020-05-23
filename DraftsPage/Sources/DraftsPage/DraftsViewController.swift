import FyreplaceKit
import UIKit

public class DraftsViewController: UIViewController, AreaSelectorDelegate {
    @IBOutlet
    private var areaSelector: AreaSelector!

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        areaSelector.createAreaPicker(inside: view)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        areaSelector.destroyAreaPicker()
    }

    @IBAction
    private func didClickArea() {
        areaSelector.toggleAreaPicker()
    }
}
