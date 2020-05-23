import Foundation
import FyreplaceKit
import WildFyreKit

class LoginViewModel: NSObject {
    @IBOutlet
    private var authRepo: AuthRepository!

    public func login(username: String, password: String) {
        authRepo.login(Auth(username: username, password: password))
    }
}
