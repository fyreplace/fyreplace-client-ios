import Foundation
import Moya

public struct Author: Decodable {
    public let user: UInt64
    public let name: String
    public let avatar: URL?
    public let bio: String?
    public let banned: Bool

    public struct Patch: Encodable {
        public let bio: String

        public init(bio: String) {
            self.bio = bio
        }
    }
}

public enum AuthorTarget {
    case user(id: UInt64?)
    case updateBio(text: String)
    case updateAvatar(image: ImageData)
}

extension AuthorTarget: TargetType, AccessTokenAuthorizable {
    public var path: String {
        switch self {
        case .user(nil),
             .updateBio,
             .updateAvatar:
            return "/users/"

        case let .user(id):
            return "/users/\(id ?? 0)/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .user:
            return .get

        case .updateBio:
            return .patch

        case .updateAvatar:
            return .put
        }
    }

    public var task: Task {
        switch self {
        case .user:
            return .requestPlain

        case let .updateBio(text):
            return .requestJSONEncodable(Author.Patch(bio: text))

        case let .updateAvatar(image):
            return .uploadMultipart([image.formData(named: "avatar")])
        }
    }
}
