import Foundation
import Moya

public class Area: NSObject, Decodable {
    public let name: String
    public let displayname: String
}

public class Reputation: NSObject, Decodable {
    public let reputation: Int
    public let spread: Int
}

public enum AreaTarget {
    case all
    case reputation(areaName: String)
}

extension AreaTarget: TargetType, AccessTokenAuthorizable {
    public var path: String {
        switch self {
        case .all:
            return "/areas/"

        case let .reputation(areaName):
            return "/areas/\(areaName)/rep/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .all,
             .reputation:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case .all,
             .reputation:
            return .requestPlain
        }
    }
}
