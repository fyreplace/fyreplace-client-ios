import Foundation
import Lib

class MainViewModel: NSObject {
    public var isLogged: Bool { Keychain.authToken.get() != nil }
}
