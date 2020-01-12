import Alamofire
import Foundation
import LibCommon
import LibWildFyre
import RxSwift

class SettingsViewModel: NSObject {
    @IBOutlet private var authRepo: AuthRepository!

    public func logout() {
        authRepo.logout()
    }
}
