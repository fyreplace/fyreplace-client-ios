import RxSwift
import UIKit

class MainViewController: UITabBarController {
    @IBOutlet private var viewModel: MainViewModel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.isLogged
            .subscribe(onNext: { [unowned self] in self.loginStateChanged(logged: $0) })
            .disposed(by: disposeBag)
    }

    override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        let isPhone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
        let traits = [
            UITraitCollection(horizontalSizeClass: isPhone ? .compact : .regular),
            UITraitCollection(verticalSizeClass: view.bounds.width < view.bounds.height ? .regular : .compact)
        ]

        return UITraitCollection(traitsFrom: traits)
    }

    private func loginStateChanged(logged: Bool) {
        guard let items = tabBar.items else { return }

        if !logged {
            selectedIndex = items.count - 1
        }

        for item in items {
            item.isEnabled = logged || item == items.last
        }
    }
}
