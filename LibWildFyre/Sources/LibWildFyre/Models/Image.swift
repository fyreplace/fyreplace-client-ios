import Foundation
import Moya

public struct Image: Decodable {
    public let num: UInt
    public let image: String
    public let comment: String?
}

public struct ImageData: Encodable {
    public var name: String
    public var mime: String
    public var data: Data

    internal func formData(named name: String) -> MultipartFormData {
        MultipartFormData(
            provider: .data(data),
            name: name,
            fileName: self.name,
            mimeType: mime
        )
    }
}
