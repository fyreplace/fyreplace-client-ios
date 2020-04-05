import Foundation

class MainViewModel: NSObject {
    public var isLogged: Bool {
        UserDefaults.standard.string(forKey: .authTokenDefaultsKey)?.count ?? 0 > 0
    }
}
