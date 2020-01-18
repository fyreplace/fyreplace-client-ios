import Lib
import RxSwift
import SDWebImage
import UIKit

public class SettingsViewController: UIViewController, CentralDataConsumer {
    public var centralViewModel: CentralViewModel!
    @IBOutlet private var viewModel: SettingsViewModel!
    @IBOutlet private var avatar: UIImageView!
    @IBOutlet private var username: UILabel!
    private var disposer = DisposeBag()

    public override func viewDidLoad() {
        avatar.sd_imageTransition = .fade
    }

    public override func viewDidAppear(_ animated: Bool) {
        centralViewModel.username.purify(with: self)
            .subscribe(onNext: { [unowned self] name in self.username.text = name })
            .disposed(by: disposer)

        centralViewModel.avatar.purify(with: self)
            .subscribe(onNext: { [unowned self] avatar in
                if let avatar = avatar {
                    self.avatar.sd_setImage(with: URL(string: avatar), placeholderImage: UIImage(named: "Avatar"))
                }
            })
            .disposed(by: disposer)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        disposer = DisposeBag()
    }

    @IBAction func didClickLogout() {
        viewModel.logout()
    }
}
