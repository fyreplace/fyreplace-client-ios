import Foundation
import LibWildFyre
import RxSwift

public class CentralViewModel: NSObject {
    @IBOutlet
    private var authorRepo: AuthorRepository!

    public lazy var user = mFutureUser.merge().share(replay: 1)
    public lazy var username = user.map { $0.name }
    public lazy var avatar = user.map { $0.avatar }
    public lazy var bio = user.map { $0.bio }
    public var isLogged: Bool { Keychain.authToken.get() != nil }

    private var mFutureUser = ReplaySubject<Observable<Author>>.create(bufferSize: 1)

    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogin(_:)), name: .didLogin, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public func updateBio(text: String) {
        mFutureUser.onNext(authorRepo.updateBio(text: text))
    }

    public func updateAvatar(image: ImageData) {
        mFutureUser.onNext(authorRepo.updateAvatar(avatar: image))
    }

    @objc
    private func onDidLogin(_ notification: Foundation.Notification) {
        guard let success = notification.userInfo?[String.didLoginSuccessUserInfoKey] as? Bool, success
            else { return }
        mFutureUser.onNext(authorRepo.getUser())
    }
}
