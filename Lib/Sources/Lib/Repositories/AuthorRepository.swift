import Foundation
import LibWildFyre
import RxSwift

public class AuthorRepository: NSObject {
    private let provider = BaseProvider<AuthorTarget>()

    public func getUser() -> Observable<Author> {
        provider.req(.user(id: nil), as: Author.self)
    }
}
