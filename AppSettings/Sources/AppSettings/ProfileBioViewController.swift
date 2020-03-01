import Lib
import RxCocoa
import RxSwift
import UIKit

public class ProfileBioViewController: UIViewController, CentralDataConsumer {
    @IBOutlet
    private var textView: UITextView!

    public var centralViewModel: CentralViewModel!
    private var disposer = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        centralViewModel.bio.purify(with: self)
            .bind(to: textView.rx.text)
            .disposed(by: disposer)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }

    @IBAction
    private func didCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @IBAction
    private func didDone(_ sender: UIBarButtonItem) {
        centralViewModel.updateBio(text: textView.text)
        dismiss(animated: true)
    }
}
