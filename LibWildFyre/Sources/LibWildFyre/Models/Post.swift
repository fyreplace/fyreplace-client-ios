import Foundation
import Moya

public struct Post: Codable {
    public let id: UInt64
    public let author: Author
    public let text: String
    public let anonym: Bool
    public let subscribed: Bool
    public let created: Date
    public let active: Bool
    public let image: String?
    public let additionalImages: [Image]
    public let comments: [Comment]
}

public struct Spread: Codable {
    public let spread: Bool
}

public struct Subscription: Codable {
    public let subscribed: Bool
}

public enum PostTarget {
    case stack(areaName: String, limit: UInt)
    case archive(areaName: String, offset: UInt, limit: UInt)
    case own(areaName: String, offset: UInt, limit: UInt)
    case get(areaName: String, postId: UInt64)
    case create(areaName: String, post: Post)
    case delete(areaName: String, postId: UInt64)
    case spread(areaName: String, postId: UInt64, spread: Spread)
    case subscribe(areaName: String, postId: UInt64, subscription: Subscription)
}

extension PostTarget: TargetType {
    public var path: String {
        switch self {
        case let .stack(areaName, _),
             let .create(areaName, _):
            return "/areas/\(areaName)/"

        case let .archive(areaName, _, _):
            return "/areas/\(areaName)/subscribed/"

        case let .own(areaName, _, _):
            return "/areas/\(areaName)/own/"

        case let .get(areaName, postId),
             let .delete(areaName, postId):
            return "/areas/\(areaName)/\(postId)/"

        case let .spread(areaName, postId, _):
            return "/areas/\(areaName)/\(postId)/spread/"

        case let .subscribe(areaName, postId, _):
            return "/areas/\(areaName)/\(postId)/subscribe/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .stack,
             .archive,
             .own,
             .get:
            return .get

        case .create,
             .spread:
            return .post

        case .delete:
            return .delete

        case .subscribe:
            return .put
        }
    }

    public var task: Task {
        switch self {
        case let .stack(_, limit):
            return .requestParameters(parameters: pagerParams(limit), encoding: URLEncoding.default)

        case let .archive(_, limit, offset),
             let .own(_, offset, limit):
            return .requestParameters(parameters: pagerParams(limit, offset), encoding: URLEncoding.default)

        case .get,
             .delete:
            return .requestPlain

        case let .create(_, post):
            return .requestJSONEncodable(post)

        case let .spread(_, _, spread):
            return .requestJSONEncodable(spread)

        case let .subscribe(_, _, subscription):
            return .requestJSONEncodable(subscription)
        }
    }
}
