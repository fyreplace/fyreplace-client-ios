import Foundation
import LibWildFyre
import RxSwift

public class CentralViewModel: NSObject {
    @IBOutlet
    private var authorRepo: AuthorRepository!

    private lazy var futureUser = BehaviorSubject<Observable<Author>>(value: authorRepo.getUser())
    public lazy var user = futureUser.flatMap { $0 }.share(replay: 1)
    public lazy var username = user.map { $0.name }
    public lazy var avatar = user.map { $0.avatar }
    public lazy var bio = user.map { $0.bio }

    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogin(_:)), name: .didLogin, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public func updateBio(text: String) {
        futureUser.onNext(authorRepo.updateBio(text: text))
    }

    @objc
    private func onDidLogin(_ notification: Foundation.Notification) {
        guard notification.userInfo?["success"] as? Bool ?? false else { return }
        futureUser.onNext(authorRepo.getUser())
    }
}
