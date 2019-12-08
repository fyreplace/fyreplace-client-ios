import Moya

public struct Draft: Encodable {
    public let text: String
    public let anonym: Bool

    public init(text: String, anonym: Bool) {
        self.text = text
        self.anonym = anonym
    }
}

public struct DraftText: Encodable {
    public let text: String
    public let image: ImageData? = nil

    public init(text: String) {
        self.text = text
    }
}

public enum DraftTarget {
    case all(areaName: String, offset: UInt, limit: UInt)
    case get(areaName: String, postId: UInt64)
    case create(areaName: String, draft: Draft)
    case patch(areaName: String, postId: UInt64, draft: Draft)
    case publish(areaName: String, postId: UInt64)
    case delete(areaName: String, postId: UInt64)
    case setImage(areaName: String, postId: UInt64, image: ImageData, text: String)
    case clearImage(areaName: String, postId: UInt64, text: DraftText)
    case addImage(areaName: String, postId: UInt64, slotId: UInt, image: ImageData)
    case removeImage(areaName: String, postId: UInt64, slotId: UInt)
}

extension DraftTarget: TargetType, AccessTokenAuthorizable {
    public var path: String {
        switch self {
        case let .all(areaName, _, _),
             let .create(areaName, _):
            return "/areas/\(areaName)/drafts/"

        case let .get(areaName, postId),
             let .patch(areaName, postId, _),
             let .publish(areaName, postId),
             let .delete(areaName, postId),
             let .setImage(areaName, postId, _, _),
             let .clearImage(areaName, postId, _):
            return "/areas/\(areaName)/drafts/\(postId)/"

        case let .addImage(areaName, postId, slotId, _),
             let .removeImage(areaName, postId, slotId):
            return "/areas/\(areaName)/drafts/\(postId)/img/\(slotId)/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .all,
             .get:
            return .get

        case .create,
             .publish:
            return .post

        case .patch:
            return .patch

        case .setImage,
             .addImage:
            return .put

        case .delete,
             .clearImage,
             .removeImage:
            return .delete
        }
    }

    public var task: Task {
        switch self {
        case let .all(_, offset, limit):
            return .requestParameters(parameters: pagerParams(limit, offset), encoding: URLEncoding.default)

        case .get,
             .publish,
             .delete,
             .removeImage:
            return .requestPlain

        case let .create(_, draft),
             let .patch(_, _, draft):
            return .requestJSONEncodable(draft)

        case let .setImage(_, _, image, text):
            return .uploadMultipart([image.formData(named: "image"), text.formData(named: "text")])

        case let .clearImage(_, _, text):
            return .requestJSONEncodable(text)

        case let .addImage(_, _, slotId, image):
            return .uploadMultipart([image.formData(named: "image"), "Image \(slotId)".formData(named: "comment")])
        }
    }
}
