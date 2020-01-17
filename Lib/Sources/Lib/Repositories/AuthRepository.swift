import Foundation
import LibWildFyre
import RxSwift

public class AuthRepository: NSObject {
    private let provider = BaseProvider<AuthTarget>()

    public func login(_ auth: Auth) {
        let disposer = CompositeDisposable()
        provider
            .req(.login(auth: auth), as: AuthToken.self)
            .subscribe { (event) in
                var success: Bool

                switch (event) {
                case let .success(authToken):
                    success = true
                    UserDefaults.standard.set(authToken.token, forKey: "auth:token")
                case .error:
                    success = false
                }

                NotificationCenter.default.post(name: .didLogin, object: self, userInfo: ["success": success])
                disposer.dispose()
            }
            .disposed(by: disposer)
    }

    public func logout() {
        UserDefaults.standard.set("", forKey: "auth:token")
        NotificationCenter.default.post(name: .didLogout, object: self)
    }
}

public extension Foundation.Notification.Name {
    static let didLogin = Foundation.Notification.Name("didLogin")
    static let didLogout = Foundation.Notification.Name("didLogout")
}
