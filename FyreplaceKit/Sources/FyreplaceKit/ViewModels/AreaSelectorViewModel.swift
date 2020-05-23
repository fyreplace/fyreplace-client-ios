import Foundation
import RxSwift
import WildFyreKit

public class AreaSelectorViewModel: NSObject {
    public var currentAreaName: String? {
        get { areaRepo.currentArea }
        set { areaRepo.currentArea = newValue }
    }
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
}
