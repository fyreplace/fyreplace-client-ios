import Foundation
import RxSwift
import WildFyreKit

public class AuthRepository: NSObject {
    private let provider = BaseProvider<AuthTarget>()

    public func login(_ auth: Auth) {
        let disposer = CompositeDisposable()
        provider
            .rawReq(.login(auth: auth), as: AuthToken.self)
            .subscribe { (event) in
                var success = true

                switch event {
                case let .success(authToken):
                    if let data = authToken.token.data(using: .utf8) {
                        success = Keychain.authToken.set(data)
                    }
                case .error:
                    success = false
                }

                let info: [String: Any] = [.didLoginSuccessUserInfoKey: success]
                NotificationCenter.default.post(name: .didLogin, object: self, userInfo: info)
                disposer.dispose()
            }
            .disposed(by: disposer)
    }

    public func logout() {
        if Keychain.authToken.delete() {
            NotificationCenter.default.post(name: .didLogout, object: self)
        }
    }
}

public extension String {
    static let didLoginSuccessUserInfoKey = "didLogin:success"
}

public extension Foundation.Notification.Name {
    static let didLogin = Foundation.Notification.Name("didLogin")
    static let didLogout = Foundation.Notification.Name("didLogout")
}
