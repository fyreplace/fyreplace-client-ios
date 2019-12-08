import Foundation
import Moya

public struct Auth: Encodable {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

public struct AuthToken: Decodable {
    public let token: String
}

public struct Registration: Encodable {
    public let username: String
    public let email: String
    public let password: String
    public let captcha: String

    public init(username: String, email: String, password: String, captcha: String) {
        self.username = username
        self.email = email
        self.password = password
        self.captcha = captcha
    }
}

public struct RegistrationResult: Decodable {}

public enum AuthTarget {
    case login(auth: Auth)
    case register(registration: Registration)
}

extension AuthTarget: TargetType, AccessTokenAuthorizable {
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

    public var authorizationType: AuthorizationType { .none }
}
