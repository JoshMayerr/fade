import Foundation
import SwiftUI
import UIKit

@MainActor
final class ProfileManager: ObservableObject {
    static let shared = ProfileManager()

    @Published var friends: [FriendProfile] = []
    @Published var lastErrorMessage: String?

    private let api = APIClient.shared
    private let keychain = KeychainService()
    private let writeTokenKey = "fade.writeToken"
    private let shareIdKey = "fade.shareId"
    private let displayNameKey = "profileDisplayName"

    var shareId: String? {
        UserDefaults.standard.string(forKey: shareIdKey)
    }

    var displayName: String {
        if let stored = UserDefaults.standard.string(forKey: displayNameKey), !stored.isEmpty {
            return stored
        }
        return UIDevice.current.name
    }

    func ensureProfile() async {
        if writeToken != nil, shareId != nil {
            return
        }

        do {
            let response: CreateProfileResponse = try await api.request(
                path: "api/profile/create",
                method: "POST",
                body: CreateProfileRequest(displayName: displayName.isEmpty ? nil : displayName)
            )

            keychain.save(response.writeToken, account: writeTokenKey)
            UserDefaults.standard.set(response.shareId, forKey: shareIdKey)
        } catch {
            lastErrorMessage = error.localizedDescription
        }
    }

    func startBlocking() async -> Date? {
        await ensureProfile()
        guard let writeToken else { return nil }

        do {
            let response: StartResponse = try await api.request(
                path: "api/profile/start",
                method: "POST",
                authToken: writeToken
            )
            return response.startAt
        } catch {
            lastErrorMessage = error.localizedDescription
            return nil
        }
    }

    func updateDisplayName(_ name: String) async {
        await ensureProfile()
        guard let writeToken else { return }

        let cleaned = name.trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults.standard.set(cleaned, forKey: displayNameKey)

        do {
            let _: UpdateProfileResponse = try await api.request(
                path: "api/profile/update",
                method: "PATCH",
                body: UpdateProfileRequest(displayName: cleaned.isEmpty ? nil : cleaned),
                authToken: writeToken
            )
        } catch {
            lastErrorMessage = error.localizedDescription
        }
    }

    func createInvite() async throws -> URL {
        await ensureProfile()
        guard let writeToken else { throw APIError.unauthorized }

        let response: InviteResponse = try await api.request(
            path: "api/invite/create",
            method: "POST",
            authToken: writeToken
        )
        guard let url = URL(string: response.inviteUrl) else {
            throw APIError.invalidResponse
        }
        return url
    }

    func acceptInvite(code: String) async {
        await ensureProfile()
        guard let writeToken else { return }

        do {
            let _: AcceptInviteResponse = try await api.request(
                path: "api/invite/accept",
                method: "POST",
                body: AcceptInviteRequest(inviteCode: code),
                authToken: writeToken
            )
            await fetchFriends()
        } catch {
            lastErrorMessage = error.localizedDescription
        }
    }

    func fetchFriends() async {
        await ensureProfile()
        guard let writeToken else { return }

        do {
            let response: FriendsResponse = try await api.request(
                path: "api/friends",
                method: "GET",
                authToken: writeToken
            )
            friends = response.friends
        } catch {
            lastErrorMessage = error.localizedDescription
        }
    }

    func handleDeepLink(_ url: URL) async {
        let path = url.pathComponents
        guard path.count >= 3 else { return }
        let type = path[1]
        let code = path[2]

        if type == "i" {
            await acceptInvite(code: code)
        }
    }

    private var writeToken: String? {
        keychain.read(account: writeTokenKey)
    }
}

private struct CreateProfileRequest: Encodable {
    let displayName: String?
}

private struct CreateProfileResponse: Decodable {
    let shareId: String
    let writeToken: String
}

private struct StartResponse: Decodable {
    let startAt: Date?
}

private struct UpdateProfileRequest: Encodable {
    let displayName: String?
}

private struct UpdateProfileResponse: Decodable {
    let ok: Bool
}

private struct InviteResponse: Decodable {
    let inviteUrl: String
}

private struct AcceptInviteRequest: Encodable {
    let inviteCode: String
}

private struct AcceptInviteResponse: Decodable {
    let ok: Bool
}

private struct FriendsResponse: Decodable {
    let friends: [FriendProfile]
}
