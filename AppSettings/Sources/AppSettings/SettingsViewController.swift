import LibCommon
import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet private var viewModel: SettingsViewModel!

    @IBAction func didClickLogout() {
        viewModel.logout()
    }
}
