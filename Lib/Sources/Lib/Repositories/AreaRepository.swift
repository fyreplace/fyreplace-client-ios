import Foundation
import LibWildFyre
import RxSwift

public class AreaRepository: NSObject {
    public var currentArea: String? {
        get {
            UserDefaults.standard.string(forKey: .areaCurrentDefaultsKey)
        }

        set {
            guard let name = newValue else { return }

            if name != currentArea {
                let info: [String: Any] = [.didChangeAreaCurrentUserInfoKey: name]
                UserDefaults.standard.set(name, forKey: .areaCurrentDefaultsKey)
                NotificationCenter.default.post(name: .didChangeArea, object: self, userInfo: info)
            }
        }
    }

    private let provider = BaseProvider<AreaTarget>()

    public func getAreas() -> Observable<[Area]> {
        provider.req(.all, as: [Area].self)
    }

    public func getReputation(for name: String) -> Observable<Reputation> {
        provider.req(.reputation(areaName: name), as: Reputation.self)
    }
}

public extension String {
    static let areaCurrentDefaultsKey = "area:current"
    static let didChangeAreaCurrentUserInfoKey = "didChangeArea:current"
}

public extension Foundation.Notification.Name {
    static let didChangeArea = Foundation.Notification.Name("didChangeArea")
}
