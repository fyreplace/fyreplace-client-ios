import Foundation
import Moya

public class PasswordRecoveryStep1: NSObject, Encodable {
    public let username: String
    public let email: String
    public let captcha: String

    public init(username: String, email: String, captcha: String) {
        self.username = username
        self.email = email
        self.captcha = captcha
    }
}

public class PasswordRecoveryStep2: NSObject, Encodable {
    public let newPassword: String
    public let token: String
    public let transaction: String
    public let captcha: String

    public init(newPassword: String, token: String, transaction: String, captcha: String) {
        self.newPassword = newPassword
        self.token = token
        self.transaction = transaction
        self.captcha = captcha
    }
}

public class RecoverTransaction: NSObject, Decodable {
    public let transaction: String
}

public class Reset: NSObject, Decodable {}

public class UsernameRecovery: NSObject, Encodable {
    public let email: String
    public let captcha: String

    public init(email: String, captcha: String) {
        self.email = email
        self.captcha = captcha
    }
}

public enum RecoveryTarget {
    case passwordStep1(recovery: PasswordRecoveryStep1)
    case passwordStep2(recovery: PasswordRecoveryStep2)
    case username(recovery: UsernameRecovery)
}

extension RecoveryTarget: TargetType, AccessTokenAuthorizable {
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
