import Foundation
import LibWildFyre
import RxSwift

public class CentralViewModel: NSObject {
    @IBOutlet private var authorRepo: AuthorRepository!
    private let mUser = BehaviorSubject<Void>(value: Void())

    public lazy var user = mUser.flatMap { [unowned self] _ in self.authorRepo.getUser() }.share()
    public lazy var username = user.map { $0.name }
    public lazy var avatar = user.map { $0.avatar }

    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogin(_:)), name: .didLogin, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func onDidLogin(_ notification: Foundation.Notification) {
        guard notification.userInfo?["success"] as? Bool ?? false else { return }
        mUser.onNext(Void())
    }
}
