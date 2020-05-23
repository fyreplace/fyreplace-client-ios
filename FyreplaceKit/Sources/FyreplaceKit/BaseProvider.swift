import Foundation
import Moya
import RxMoya
import RxSwift

public class BaseProvider<T: TargetType>: MoyaProvider<T> {
    private let defaultScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    private let decoder = JSONDecoder()

    public init() {
        decoder.dateDecodingStrategy = .formatted(ProperDateFormatter())
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let tokenPlugin = AccessTokenPlugin { _ in (String(data: Keychain.authToken.get() ?? Data(), encoding: .utf8) ?? "" ) }
        super.init(plugins: [tokenPlugin])
    }

    public func req<R: Decodable>(_ token: T, as type: R.Type) -> Observable<R> {
        rawReq(token, as: type).asObservable()
    }

    public func rawReq<R: Decodable>(_ token: T, as type: R.Type) -> Single<R> {
        rx.request(token)
            .observeOn(defaultScheduler)
            .filterSuccessfulStatusCodes()
            .map(type, using: decoder)
    }
}

private class ProperDateFormatter: DateFormatter {
    private let formatter: ISO8601DateFormatter = {
        var result = ISO8601DateFormatter()
        result.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return result
    }()

    override func string(from date: Date) -> String {
        formatter.string(from: date)
    }

    override func date(from string: String) -> Date? {
        formatter.date(from: string)
    }
}
