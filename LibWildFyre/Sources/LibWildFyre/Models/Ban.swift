import Foundation
import Moya

public struct Ban: Decodable {
    public let timestamp: Date
    public let reason: UInt64
    public let comment: String?
    public let expiry: Date
    public let auto: Bool?
    public let banAll: Bool?
    public let banPost: Bool?
    public let banComment: Bool?
    public let banFlag: Bool
}

public enum BanTarget {
    case all
}

extension BanTarget: TargetType, AccessTokenAuthorizable {
    public var path: String {
        switch self {
        case .all:
            return "/bans/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .all:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case .all:
            return .requestPlain
        }
    }
}
