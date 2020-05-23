import Foundation

public extension String {
    static func tr(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
}
