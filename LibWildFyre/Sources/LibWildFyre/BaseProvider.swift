import Foundation
import Moya
import RxMoya
import RxSwift

public class BaseProvider<T: TargetType>: MoyaProvider<T> {
    public init() {
        let tokenPlugin = AccessTokenPlugin { _ in UserDefaults.standard.string(forKey: "auth:token") ?? "" }
        super.init(plugins: [tokenPlugin])
    }

    public func req<R: Decodable>(_ token: T, as type: R.Type) -> Single<R> {
        rx.request(token).map(type)
    }
}
