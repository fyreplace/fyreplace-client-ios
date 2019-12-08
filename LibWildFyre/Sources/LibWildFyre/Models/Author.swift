import Moya

public struct Author: Decodable {
    public let user: UInt64
    public let name: String
    public let avatar: String?
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
    case me
    case user(id: UInt64)
    case updateBio(text: String)
    case updateAvatar(image: ImageData)
}

extension AuthorTarget: TargetType, AccessTokenAuthorizable {
    public var path: String {
        switch self {
        case .me,
             .updateBio,
             .updateAvatar:
            return "/users/"

        case let .user(id):
            return "/users/\(id)/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .me,
             .user:
            return .get

        case .updateAvatar:
            return .put

        case .updateBio:
            return .patch
        }
    }

    public var task: Task {
        switch self {
        case .me,
             .user:
            return .requestPlain

        case let .updateBio(text):
            return .requestJSONEncodable(Author.Patch(bio: text))

        case let .updateAvatar(image):
            return .uploadMultipart([image.formData(named: "avatar")])
        }
    }
}
