import Foundation
import Lib
import LibWildFyre

class LoginViewModel: NSObject {
    @IBOutlet
    private var authRepo: AuthRepository!

    public func login(username: String, password: String) {
        authRepo.login(Auth(username: username, password: password))
    }
}
