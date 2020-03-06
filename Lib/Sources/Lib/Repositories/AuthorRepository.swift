import Foundation
import LibWildFyre
import RxSwift

public class AuthorRepository: NSObject {
    private let provider = BaseProvider<AuthorTarget>()

    public func getUser() -> Observable<Author> {
        provider.req(.user(id: nil), as: Author.self)
    }

    public func updateBio(text: String) -> Observable<Author> {
        provider.req(.updateBio(text: text), as: Author.self)
    }

    public func updateAvatar(avatar: ImageData) -> Observable<Author> {
        provider.req(.updateAvatar(image: avatar), as: Author.self)
    }
}
