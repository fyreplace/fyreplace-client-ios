import FyreplaceKit
import UIKit

public class HomeViewController: UIViewController, AreaSelectorDelegate, CentralDataConsumer {
    @IBOutlet
    private var areaSelector: AreaSelector!

    public var centralViewModel: CentralViewModel!

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if centralViewModel.isLogged {
            start()
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(onDidLogin(_:)), name: .didLogin, object: nil)
        }
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        areaSelector.destroyAreaPicker()
    }

    @IBAction
    private func didClickArea() {
        areaSelector.toggleAreaPicker()
    }

    @objc
    private func onDidLogin(_ notification: Notification) {
        guard notification.userInfo?[String.didLoginSuccessUserInfoKey] as? Bool == true else { return }
        start()
    }

    private func start() {
        DispatchQueue.main.async { self.areaSelector.createAreaPicker(inside: self.view) }
    }
}
