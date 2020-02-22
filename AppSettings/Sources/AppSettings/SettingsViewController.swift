import Lib
import RxCocoa
import RxSwift
import SDWebImage
import UIKit

public class SettingsViewController: UIViewController, CentralDataProvider {
    @IBOutlet
    private var viewModel: SettingsViewModel!
    @IBOutlet
    private var avatar: UIImageView!
    @IBOutlet
    private var username: UILabel!
    @IBOutlet
    private var bio: UITextView!

    public var centralViewModel: CentralViewModel!
    private var disposer = DisposeBag()

    public override func viewDidLoad() {
        avatar.sd_imageTransition = .fade
    }

    public override func viewWillAppear(_ animated: Bool) {
        centralViewModel.username.purify(with: self)
            .bind(to: username.rx.text)
            .disposed(by: disposer)

        centralViewModel.bio.purify(with: self)
            .bind(to: bio.rx.text)
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

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setup(viewController: segue.destination)
    }

    @IBAction
    func didClickLogout() {
        viewModel.logout()
    }
}
