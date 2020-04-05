import Lib
import UIKit

public class HomeViewController: UIViewController, AreaSelectorDelegate {
    @IBOutlet
    private var areaSelector: AreaSelector!

    public override func viewDidLoad() {
        super.viewDidLoad()
        areaSelector.delegate = self
    }

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
