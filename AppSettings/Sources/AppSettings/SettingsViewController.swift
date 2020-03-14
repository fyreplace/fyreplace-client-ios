import Lib
import LibWildFyre
import RxCocoa
import RxSwift
import SDWebImage
import UIKit

public class SettingsViewController: UIViewController, ImageSelectorDelegate, CentralDataProvider {
    @IBOutlet
    private var imageSelector: ImageSelector!
    @IBOutlet
    private var viewModel: SettingsViewModel!
    @IBOutlet
    private var avatar: UIImageView!
    @IBOutlet
    private var username: UILabel!
    @IBOutlet
    private var bio: UITextView!

    public var centralViewModel: CentralViewModel!
    public let maxImageSize: Float = 0.5
    private var disposer = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        imageSelector.delegate = self
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
        super.viewDidDisappear(animated)
        disposer = DisposeBag()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        injectData(into: segue.destination)
    }

    public func image(selected imageData: ImageData) {
        centralViewModel.updateAvatar(image: imageData)
    }

    @IBAction
    private func didClickLogout() {
        viewModel.logout()
    }

    @IBAction
    private func didClickPicture() {
        imageSelector.selectImage()
    }
}
