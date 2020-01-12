import Foundation
import LibCommon
import RxSwift

public class MainViewModel: NSObject {
    public var isLogged: Bool {
        UserDefaults.standard.string(forKey: "auth:token")?.count ?? 0 > 0
    }
}
