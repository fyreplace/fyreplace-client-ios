import Foundation
import RxSwift
import RxSwiftExt

public extension ObservableType {
    func purify(with handler: FailureHandler) -> Observable<Self.Element> {
        materialize().filterMap { [weak handler] event in
            switch event {
            case let .next(element):
                return .map(element)
            case let .error(error):
                DispatchQueue.main.async { handler?.failure(error) }
                return .ignore
            case .completed:
                return .ignore
            }
        }.observeOn(MainScheduler.instance)
    }
}
