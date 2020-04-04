import Foundation
import LibUtils
import LibWildFyre
import RxSwift

public class AuthRepository: NSObject {
    private let provider = BaseProvider<AuthTarget>()

    public func login(_ auth: Auth) {
        let disposer = CompositeDisposable()
        provider
            .rawReq(.login(auth: auth), as: AuthToken.self)
            .subscribe { (event) in
                var success: Bool

                switch (event) {
                case let .success(authToken):
                    success = true
                    UserDefaults.standard.set(authToken.token, forKey: .authTokenDefaultsKey)
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
        UserDefaults.standard.set("", forKey: .authTokenDefaultsKey)
        NotificationCenter.default.post(name: .didLogout, object: self)
    }
}

public extension String {
    static let authTokenDefaultsKey = "auth:token"
    static let didLoginSuccessUserInfoKey = "didLogin:success"
}

public extension Foundation.Notification.Name {
    static let didLogin = Foundation.Notification.Name("didLogin")
    static let didLogout = Foundation.Notification.Name("didLogout")
}
