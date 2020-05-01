import Lib
import LibUtils
import RxCocoa
import RxSwift
import UIKit

public class ProfileBioViewController: UIViewController, CentralDataConsumer {
    @IBOutlet
    private var textView: UITextView!

    public var centralViewModel: CentralViewModel!
    private let disposer = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        centralViewModel.bio.purify(with: self)
            .bind(to: textView.rx.text)
            .disposed(by: disposer)
    }

    @IBAction
    private func didClickCancel() {
        dismiss(animated: true)
    }

    @IBAction
    private func didClickDone() {
        centralViewModel.updateBio(text: textView.text)
        dismiss(animated: true)
    }
}
