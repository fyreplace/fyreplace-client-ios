import Moya

public extension Error {
    var message: String {
        var msg: String?

        if let data = (self as? MoyaError)?.response?.data {
            msg = String(data: data, encoding: .utf8)
        }

        return msg ?? localizedDescription
    }
}
