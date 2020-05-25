import FyreplaceKit
import RxCocoa
import RxSwift
import SafariServices
import SDWebImage
import UIKit
import WildFyreKit

public class SettingsViewController: UITableViewController, CentralDataConsumer {
    public var centralViewModel: CentralViewModel!
    private var currentBio = ""
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

    @IBOutlet
    private var avatarCell: UITableViewCell!
    @IBOutlet
    private var logoutCell: UITableViewCell!

    public override func viewDidLoad() {
        super.viewDidLoad()
        avatar.sd_imageTransition = .fade
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        centralViewModel.username
            .fail(with: self)
            .bind(to: username.rx.text)
            .disposed(by: disposer)

        centralViewModel.bio
            .fail(with: self)
            .subscribe(onNext: { bio in
                self.currentBio = bio ?? ""
                self.bio.text = bio
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            })
            .disposed(by: disposer)

        centralViewModel.avatar
            .fail(with: self)
            .subscribe(onNext: { self.avatar.setAvatar($0) })
            .disposed(by: disposer)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposer = DisposeBag()
    }
}

extension SettingsViewController {
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        switch cell {
        case avatarCell:
            imageSelector.selectImage()

        case logoutCell:
            viewModel.logout()

        default:
            if let cell = cell as? LinkCell {
                let safari = SFSafariViewController(url: URL(string: cell.link)!)
                safari.preferredControlTintColor = .systemOrange
                safari.delegate = self
                present(safari, animated: true)
                return
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsViewController: ImageSelectorDelegate {
    public static let maxImageSize: Float = 0.5

    public func imageSelector(_ imageSelector: ImageSelector, didSelectImage image: ImageData) {
        centralViewModel.updateAvatar(image: image)
    }
}

extension SettingsViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didClickCancel)), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didClickDone)), animated: true)
        navigationItem.rightBarButtonItem?.style = .done
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        navigationItem.setLeftBarButton(nil, animated: true)
        navigationItem.setRightBarButton(nil, animated: true)
    }

    public func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
        textView.becomeFirstResponder()
    }

    @objc
    private func didClickCancel() {
        bio.text = currentBio
        bio.endEditing(false)
    }

    @objc
    private func didClickDone() {
        centralViewModel.updateBio(text: bio.text)
        bio.endEditing(false)
    }
}

extension SettingsViewController: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
