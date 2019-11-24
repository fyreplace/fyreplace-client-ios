import Moya

public struct Area: Codable {
    public let name: String
    public let displayname: String
}

public enum AreaTarget {
    case all
    case reputation(areaName: String)
}

extension AreaTarget: TargetType {
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
