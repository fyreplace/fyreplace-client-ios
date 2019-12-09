import Foundation
import LibCommon
import RxSwift

public class MainViewModel: NSObject {
    @IBOutlet private var authRepo: AuthRepository! {
        didSet {
            isLogged = authRepo.authToken.map { token in !token.isEmpty }
        }
    }

    public var isLogged: Observable<Bool>!
}
