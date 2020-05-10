import Foundation
import LibWildFyre
import RxSwift

public class AreaSelectorViewModel: NSObject {
    public var currentAreaName: String? { areaRepo.currentArea }
    public lazy var areas = mFutureAreas.merge()

    private var mFutureAreas = ReplaySubject<Observable<[Area]>>.create(bufferSize: 1)

    @IBOutlet
    private var areaRepo: AreaRepository!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public func updateAreas() {
        mFutureAreas.onNext(areaRepo.getAreas())
    }

    public func setCurrentArea(name: String, force: Bool = true) {
        if force || areaRepo.currentArea == nil {
            areaRepo.currentArea = name
        }
    }
}
