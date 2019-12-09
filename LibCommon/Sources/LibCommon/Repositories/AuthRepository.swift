import Alamofire
import Foundation
import LibWildFyre
import RxSwift

public class AuthRepository: NSObject {
    private let provider = BaseProvider<AuthTarget>()
    private let mAuthToken = BehaviorSubject<String>(value: UserDefaults.standard.string(forKey: "auth.token") ?? "")

    public var authToken: Observable<String> { mAuthToken }

    public func login(_ auth: Auth) {
        mAuthToken.feed(
            provider
                .req(.login(auth: auth), as: AuthToken.self)
                .map { authToken in
                    UserDefaults.standard.setValue(authToken.token, forKey: "auth.token")
                    return authToken.token
                }
        )
    }

    public func logout() {
        mAuthToken.onNext("")
    }
}
