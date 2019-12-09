import Alamofire
import Foundation
import LibCommon
import LibWildFyre
import RxSwift

class SettingsViewModel: NSObject {
    @IBOutlet private var authRepo: AuthRepository!

    private let disposeBag = DisposeBag()

    public func login(username: String, password: String) {
        authRepo.login(Auth(username: username, password: password))
    }
}
