import RxSwift

extension ObserverType {
    public func feed(_ element: Single<Element>) {
        let cd = CompositeDisposable()
        _ = cd.insert(element.subscribe { (event: SingleEvent<Element>) in
            switch event {
            case let .success(element):
                self.onNext(element)
            case let .error(error):
                self.onError(error)
            }

            cd.dispose()
        })
    }
}
