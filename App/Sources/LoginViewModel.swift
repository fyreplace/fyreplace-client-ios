import Foundation
import LibCommon
import LibWildFyre
import RxSwift

public class LoginViewModel: NSObject {
    @IBOutlet private var authRepo: AuthRepository!

    public func login(username: String, password: String) {
        authRepo.login(Auth(username: username, password: password))
    }
}
