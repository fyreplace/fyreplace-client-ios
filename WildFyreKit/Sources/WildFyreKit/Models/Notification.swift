import Foundation
import Moya

public class Notification: NSObject, Decodable {
    public let area: String
    public let post: NotificationPost
    public let comments: [UInt64]
}

public class NotificationPost: NSObject, Decodable {
    public let id: UInt64
    public let author: Author?
    public let text: String
}

public enum NotificationTarget {
    case all
    case clear
}

extension NotificationTarget: TargetType, AccessTokenAuthorizable {
    public var path: String {
        switch self {
        case .all,
             .clear:
            return "/areas/notification/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .all:
            return .get

        case .clear:
            return .delete
        }
    }

    public var task: Task {
        switch self {
        case .all,
             .clear:
            return .requestPlain
        }
    }
}
