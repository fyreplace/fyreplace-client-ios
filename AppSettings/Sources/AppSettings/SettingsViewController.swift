import Lib
import LibUtils
import LibWildFyre
import RxCocoa
import RxSwift
import SDWebImage
import UIKit

public class SettingsViewController: UIViewController, CentralDataProvider {
    public var centralViewModel: CentralViewModel!
    public let maxImageSize: Float = 0.5
    private var disposer = DisposeBag()

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

    public override func viewDidLoad() {
        super.viewDidLoad()
        imageSelector.delegate = self
        avatar.sd_imageTransition = .fade
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        centralViewModel.username
            .purify(with: self)
            .bind(to: username.rx.text)
            .disposed(by: disposer)

        centralViewModel.bio
            .purify(with: self)
            .bind(to: bio.rx.text)
            .disposed(by: disposer)

        centralViewModel.avatar
            .purify(with: self)
            .subscribe(onNext: { avatar in
                guard self.avatar.sd_imageURL?.absoluteString != avatar else { return }

                if let avatar = avatar {
                    self.avatar.sd_setImage(with: URL(string: avatar))
                } else {
                    self.avatar.image = #imageLiteral(resourceName: "Avatar")
                }
            })
            .disposed(by: disposer)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposer = DisposeBag()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        injectData(into: segue.destination)
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

extension SettingsViewController: ImageSelectorDelegate {
    public func imageSelector(_ imageSelector: ImageSelector, didSelectImage image: ImageData) {
        centralViewModel.updateAvatar(image: image)
    }
}
