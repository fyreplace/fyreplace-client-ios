import Moya

public struct Auth: Codable {
    public let username: String
    public let password: String
}

public struct Registration: Codable {
    public let username: String
    public let email: String
    public let password: String
    public let captcha: String
}

public struct RegistrationResult: Codable {}

public enum AuthTarget {
    case login(auth: Auth)
    case register(registration: Registration)
}

extension AuthTarget: TargetType {
    public var path: String {
        switch self {
        case .login:
            return "/account/auth/"

        case .register:
            return "/account/register/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .login,
             .register:
            return .post
        }
    }

    public var task: Task {
        switch self {
        case let .login(auth):
            return .requestJSONEncodable(auth)

        case let .register(registration):
            return .requestJSONEncodable(registration)
        }
    }
}
