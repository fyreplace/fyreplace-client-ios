import Foundation
import Security

public struct Keychain {
    public static let authToken = Keychain(securityClass: kSecClassGenericPassword, service: "auth:token")
    private let securityClass: CFString
    private let service: String
    private var query: [CFString: Any] {
        [kSecClass: securityClass, kSecAttrService: service]
    }

    private init(securityClass: CFString, service: String) {
        self.securityClass = securityClass
        self.service = service
    }

    public func get() -> Data? {
        var info: [CFString: Any] = query
        info[kSecReturnData] = true
        var data: CFTypeRef?
        SecItemCopyMatching(info as CFDictionary, &data)
        return data as? Data
    }

    public func set(_ data: Data) -> Bool {
        var info: [CFString : Any] = query
        info[kSecValueData] = data
        let result = SecItemAdd(info as CFDictionary, nil)
        return result == errSecSuccess
    }

    public func delete() -> Bool {
        SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
