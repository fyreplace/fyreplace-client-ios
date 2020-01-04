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

    override func overrideTraitCollection(forChild _: UIViewController) -> UITraitCollection? {
        let traits = [
            UITraitCollection(horizontalSizeClass: UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? .compact : .regular),
            UITraitCollection(verticalSizeClass: view.bounds.width < view.bounds.height ? .regular : .compact),
        ]

        return UITraitCollection(traitsFrom: traits)
    }

    private func loginStateChanged(logged: Bool) {
        if !logged {
            selectedIndex = tabBar.items!.count - 1
        }

        for item in tabBar.items! {
            item.isEnabled = logged || item == tabBar.items!.last
        }
    }
}
