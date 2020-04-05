import Foundation
import LibWildFyre
import RxSwift

public class AreaSelectorViewModel: NSObject {
    @IBOutlet
    private var areaRepo: AreaRepository!

    private var mFutureAreas = ReplaySubject<Observable<[Area]>>.create(bufferSize: 1)
    private var mCurrentAreaName = ReplaySubject<String>.create(bufferSize: 1)
    public lazy var areas = mFutureAreas.merge()
    public lazy var currentAreaIndex = Observable<Int?>.combineLatest(areas, mCurrentAreaName)
    { [unowned self] areas, current in
        areas.firstIndex { $0.name == current }
    }
    public lazy var currentArea = Observable<Area?>.combineLatest(areas, mCurrentAreaName)
    { [unowned self] areas, current in
        if current.isEmpty {
            guard let area = areas.first else { return nil }
            self.setCurrentArea(name: area.name)
            return area
        } else {
            return areas.first { $0.name == current }
        }
    }

    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeArea(_:)), name: .didChangeArea, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        if let current = areaRepo.currentArea {
            mCurrentAreaName.onNext(current)
        }
    }

    public func updateAreas() {
        mFutureAreas.onNext(areaRepo.getAreas())
    }

    public func setCurrentArea(name: String) {
        areaRepo.currentArea = name
    }

    @objc
    private func didChangeArea(_ notification: Foundation.Notification) {
        guard let name = notification.userInfo?[String.didChangeAreaCurrentUserInfoKey] as? String else { return }
        mCurrentAreaName.onNext(name)
    }
}
