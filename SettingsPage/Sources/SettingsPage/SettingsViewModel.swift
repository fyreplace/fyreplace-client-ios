import Foundation
import FyreplaceKit

class SettingsViewModel: NSObject {
    @IBOutlet
    private var authRepo: AuthRepository!

    public func logout() {
        authRepo.logout()
    }
}
