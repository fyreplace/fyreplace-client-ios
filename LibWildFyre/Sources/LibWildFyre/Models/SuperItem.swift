public struct SuperItem<I: Codable>: Codable {
    public let count: UInt
    public let next: String?
    public let previous: String?
    public let results: [I]
}

public typealias SuperBan = SuperItem<Ban>

public typealias SuperNotification = SuperItem<Notification>

public typealias SuperPost = SuperItem<Post>
