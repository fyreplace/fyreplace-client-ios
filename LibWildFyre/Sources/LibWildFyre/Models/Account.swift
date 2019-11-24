import Foundation
import Moya

public struct Account: Codable {
    public let id: UInt64
    public let username: String
    public let email: String?

    public struct Patch: Codable {
        public let email: String?
        public let password: String?
    }
}

public enum AccountTarget {
    case account
    case updateAccount(email: String, password: String)
}

extension AccountTarget: TargetType {
    public var path: String {
        switch self {
        case .account,
             .updateAccount:
            return "/account/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .account:
            return .get

        case .updateAccount:
            return .patch
        }
    }

    public var task: Task {
        switch self {
        case .account:
            return .requestPlain

        case let .updateAccount(email, password):
            return .requestJSONEncodable(Account.Patch(email: email, password: password))
        }
    }
}
