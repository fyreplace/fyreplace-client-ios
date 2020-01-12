import LibCommon
import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet private var viewModel: SettingsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didClickLogout() {
        viewModel.logout()
    }
}
