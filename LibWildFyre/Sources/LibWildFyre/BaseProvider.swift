import Foundation
import Moya
import RxMoya
import RxSwift

public class BaseProvider<T: TargetType>: MoyaProvider<T> {
    private let defaultScheduler = ConcurrentDispatchQueueScheduler(qos: .default)

    public init() {
        let tokenPlugin = AccessTokenPlugin { _ in UserDefaults.standard.string(forKey: "auth:token") ?? "" }
        super.init(plugins: [tokenPlugin])
    }

    public func req<R: Decodable>(_ token: T, as type: R.Type) -> Observable<R> {
        rawReq(token, as: type).asObservable()
    }

    public func rawReq<R: Decodable>(_ token: T, as type: R.Type) -> Single<R> {
        rx.request(token)
            .observeOn(defaultScheduler)
            .subscribeOn(MainScheduler.instance)
            .filterSuccessfulStatusCodes()
            .map(type)
    }
}
