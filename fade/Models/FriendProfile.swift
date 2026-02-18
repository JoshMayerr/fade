import Foundation

struct FriendProfile: Identifiable, Decodable {
    let shareId: String
    let displayName: String?
    let startAt: Date?

    var id: String { shareId }
}
