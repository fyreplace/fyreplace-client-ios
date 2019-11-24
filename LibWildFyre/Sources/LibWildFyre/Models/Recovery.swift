import Moya

public struct PasswordRecoveryStep1: Codable {
    public let username: String
    public let email: String
    public let captcha: String
}

public struct PasswordRecoveryStep2: Codable {
    public let newPassword: String
    public let token: String
    public let transaction: String
    public let captcha: String
}

public struct RecoverTransaction: Codable {
    public let transaction: String
}

public struct Reset: Codable {}

public struct UsernameRecovery: Codable {
    public let email: String
    public let captcha: String
}

public enum RecoveryTarget {
    case passwordStep1(recovery: PasswordRecoveryStep1)
    case passwordStep2(recovery: PasswordRecoveryStep2)
    case username(recovery: UsernameRecovery)
}

extension RecoveryTarget: TargetType {
    public var path: String {
        switch self {
        case .passwordStep1:
            return "/account/recover/"

        case .passwordStep2,
             .username:
            return "/account/recover/reset/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .passwordStep1,
             .passwordStep2,
             .username:
            return .post
        }
    }

    public var task: Task {
        switch self {
        case let .passwordStep1(recovery):
            return .requestJSONEncodable(recovery)

        case let .passwordStep2(recovery):
            return .requestJSONEncodable(recovery)

        case let .username(recovery):
            return .requestJSONEncodable(recovery)
        }
    }
}
