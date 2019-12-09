import RxSwift
import UIKit

class MainViewController: UITabBarController {
    @IBOutlet private var viewModel: MainViewModel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.isLogged
            .subscribe(onNext: { [unowned self] in self.loginStateChanged($0) })
            .disposed(by: disposeBag)
    }

    private func loginStateChanged(_ logged: Bool) {
        if !logged {
            selectedIndex = tabBar.items!.count - 1
        }

        for item in tabBar.items! {
            item.isEnabled = logged || item == tabBar.items!.last
        }
    }
}
