import Foundation
import Moya

extension TargetType {
    public var baseURL: URL { URL(string: Bundle.main.infoDictionary!["LibWildFyreBaseURL"] as! String)! }

    public var sampleData: Data { Data() }

    public var headers: [String: String]? { [:] }

    internal func pagerParams(_ limit: UInt, _ offset: UInt? = nil) -> [String: UInt] {
        var params = ["limit": limit]

        if offset != nil {
            params["offset"] = offset
        }

        return params
    }
}

extension AccessTokenAuthorizable {
    public var authorizationType: AuthorizationType? { .custom("Token") }
}

extension String {
    internal func formData(named name: String) -> MultipartFormData {
        MultipartFormData(provider: .data(data(using: .utf8)!), name: name)
    }
}
