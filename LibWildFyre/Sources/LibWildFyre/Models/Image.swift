import Foundation
import Moya

public class Image: NSObject, Decodable {
    public let num: Int
    public let image: URL
    public let comment: String?
}

public class ImageData: NSObject, Encodable {
    public var name: String
    public var mime: String
    public var data: Data

    public init(name: String, mime: String, data: Data) {
        self.name = name
        self.mime = mime
        self.data = data
    }

    internal func formData(named name: String) -> MultipartFormData {
        MultipartFormData(
            provider: .data(data),
            name: name,
            fileName: self.name,
            mimeType: mime
        )
    }
}
