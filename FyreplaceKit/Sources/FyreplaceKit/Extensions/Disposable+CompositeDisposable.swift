import RxSwift

public extension Disposable {
    func disposed(by disposer: CompositeDisposable) {
        _ = disposer.insert(self)
    }
}
