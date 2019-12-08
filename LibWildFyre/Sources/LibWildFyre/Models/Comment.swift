import Foundation
import Moya

public struct Comment: Decodable {
    public let id: UInt64
    public let author: Author?
    public let created: Date
    public let text: String
    public let image: String?
}

public struct CommentText: Encodable {
    public let text: String

    public init(text: String) {
        self.text = text
    }
}

public enum CommentTarget {
    case send(areaName: String, postId: UInt64, text: String, image: ImageData? = nil)
    case delete(areaName: String, postId: UInt64, commentId: UInt64)
}

extension CommentTarget: TargetType, AccessTokenAuthorizable {
    public var path: String {
        switch self {
        case let .send(areaName, postId, _, _):
            return "/areas/\(areaName)/\(postId)/"

        case let .delete(areaName, postId, commentId):
            return "/areas/\(areaName)/\(postId)/\(commentId)/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .send:
            return .post

        case .delete:
            return .delete
        }
    }

    public var task: Task {
        switch self {
        case let .send(_, _, text, image):
            if let formImage = image?.formData(named: "image") {
                return .uploadMultipart([formImage, text.formData(named: "text")])
            }

            return .requestJSONEncodable(CommentText(text: text))

        case .delete:
            return .requestPlain
        }
    }
}
