import SwiftUI

struct FriendsListView: View {
    let friends: [FriendProfile]
    let referenceDate: Date
    let onAddFriend: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Friends")
                    .font(.ibmPlexMono(size: 14, weight: .semibold))
                    .foregroundColor(.textSecondary)

                Spacer()

                Button(action: onAddFriend) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Add friend")
                            .font(.ibmPlexMono(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.onAccent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.accentBrand)
                    .cornerRadius(10)
                }
                .buttonStyle(.plain)
            }

            if friends.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("No friends yet.")
                        .font(.ibmPlexMono(size: 16, weight: .semibold))
                        .foregroundColor(.textPrimary)

                    Text("Invite someone to see their counter here.")
                        .font(.ibmPlexMono(size: 12, weight: .medium))
                        .foregroundColor(.textMuted)

                    Button(action: onAddFriend) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 12, weight: .semibold))
                            Text("Share invite link")
                                .font(.ibmPlexMono(size: 12, weight: .semibold))
                        }
                        .foregroundColor(.onAccent)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 12)
                        .background(Color.accentBrand)
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.borderHairline, lineWidth: 3)
                )
                .cornerRadius(14)
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(friends) { friend in
                            FriendRow(friend: friend, referenceDate: referenceDate)
                        }
                    }
                    .padding(.bottom, 4)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct FriendRow: View {
    let friend: FriendProfile
    let referenceDate: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(friend.displayName ?? "fade friend")
                .font(.ibmPlexMono(size: 16, weight: .semibold))
                .foregroundColor(.textPrimary)

            if let startAt = friend.startAt {
                let components = DateHelper.timeComponentsSince(date: startAt, referenceDate: referenceDate)
                Text("\(components.years)y \(components.months)m \(components.days)d \(components.hours)h \(components.minutes)m \(components.seconds)s")
                    .font(.ibmPlexMono(size: 12, weight: .medium))
                    .foregroundColor(.textSecondary)
            } else {
                Text("Not started yet")
                    .font(.ibmPlexMono(size: 12, weight: .medium))
                    .foregroundColor(.textMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color.surface)
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.borderHairline, lineWidth: 3)
        )
        .cornerRadius(14)
    }
}

#Preview {
    FriendsListView(friends: [], referenceDate: Date(), onAddFriend: {})
}
