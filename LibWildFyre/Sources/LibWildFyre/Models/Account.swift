import Foundation
import Moya

public struct Account: Decodable {
    public let id: UInt64
    public let username: String
    public let email: String?

    public struct Patch: Encodable {
        public let email: String?
        public let password: String?

        public init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }
}

public enum AccountTarget {
    case account
    case updateAccount(email: String, password: String)
}

extension AccountTarget: TargetType, AccessTokenAuthorizable {
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

    public var authorizationType: AuthorizationType { .none }
}
