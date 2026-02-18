import SwiftUI

struct FriendsView: View {
    @EnvironmentObject private var profileManager: ProfileManager
    @State private var currentTime = Date()
    @State private var shareURL: URL?
    @State private var isSharing = false
    @State private var isShowingInviteSheet = false
    @State private var inviteCode = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var displayName = UserDefaults.standard.string(forKey: "profileDisplayName") ?? ""

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your name")
                        .font(.ibmPlexMono(size: 14, weight: .semibold))
                        .foregroundColor(.textSecondary)

                    TextField("Display name", text: $displayName)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .font(.ibmPlexMono(size: 14))
                        .padding(12)
                        .background(Color.surface)
                        .cornerRadius(12)

                    Button {
                        Task {
                            await profileManager.updateDisplayName(displayName)
                        }
                    } label: {
                        Text("Save name")
                            .font(.ibmPlexMono(size: 14, weight: .semibold))
                            .foregroundColor(.onAccent)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.accentBrand)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Invite a friend")
                        .font(.ibmPlexMono(size: 14, weight: .semibold))
                        .foregroundColor(.textSecondary)

                    Button {
                        Task {
                            do {
                                let url = try await profileManager.createInvite()
                                shareURL = url
                                isSharing = true
                            } catch {
                                errorMessage = error.localizedDescription
                                showError = true
                            }
                        }
                    } label: {
                        Text("Share invite link")
                            .font(.ibmPlexMono(size: 14, weight: .semibold))
                            .foregroundColor(.onAccent)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.accentBrand)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)

                    Button {
                        inviteCode = ""
                        isShowingInviteSheet = true
                    } label: {
                        Text("Have a code? Paste it")
                            .font(.ibmPlexMono(size: 12, weight: .medium))
                            .foregroundColor(.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.surface)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)

                Text("Friends")
                    .font(.ibmPlexMono(size: 14, weight: .semibold))
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, 24)

                VStack(spacing: 12) {
                    if profileManager.friends.isEmpty {
                        Text("No friends yet.")
                            .font(.ibmPlexMono(size: 14, weight: .medium))
                            .foregroundColor(.textMuted)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                    } else {
                        ForEach(profileManager.friends) { friend in
                            FriendRow(friend: friend, referenceDate: currentTime)
                                .padding(.horizontal, 24)
                        }
                    }
                }
            }
            .padding(.vertical, 12)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            displayName = UserDefaults.standard.string(forKey: "profileDisplayName") ?? ""
            Task { await profileManager.fetchFriends() }
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
        .sheet(isPresented: $isSharing) {
            if let shareURL {
                ShareSheet(items: [shareURL])
            }
        }
        .sheet(isPresented: $isShowingInviteSheet) {
            InviteCodeSheet(inviteCode: $inviteCode) {
                let trimmed = inviteCode.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }
                Task {
                    await profileManager.acceptInvite(code: trimmed)
                }
                isShowingInviteSheet = false
            }
        }
        .onChange(of: profileManager.lastErrorMessage) { message in
            if let message {
                errorMessage = message
                showError = true
                profileManager.lastErrorMessage = nil
            }
        }
        .alert("Something went wrong", isPresented: $showError, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(errorMessage)
        })
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

private struct InviteCodeSheet: View {
    @Binding var inviteCode: String
    let onSubmit: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Paste the invite code.")
                    .font(.ibmPlexMono(size: 14, weight: .semibold))
                    .foregroundColor(.textPrimary)

                TextField("Invite code", text: $inviteCode)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .font(.ibmPlexMono(size: 14))
                    .padding(12)
                    .background(Color.surface)
                    .cornerRadius(12)

                Button(action: {
                    onSubmit()
                }) {
                    Text("Add friend")
                        .font(.ibmPlexMono(size: 14, weight: .semibold))
                        .foregroundColor(.onAccent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.accentBrand)
                        .cornerRadius(12)
                }
                .buttonStyle(.plain)
            }
            .padding(24)
            .navigationTitle("Invite code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.ibmPlexMono(size: 12, weight: .semibold))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FriendsView()
            .environmentObject(ProfileManager.shared)
    }
}
