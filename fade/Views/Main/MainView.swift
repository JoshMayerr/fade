//
//  MainView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

// MARK: - Main View

struct MainView: View {
    @StateObject private var manager = ScreenTimeManager.shared
    @EnvironmentObject private var profileManager: ProfileManager
    @AppStorage("firstBlockDate") private var firstBlockDate: Double = 0
    @AppStorage("isBlocking") private var isBlocking = false
    @AppStorage("shouldShowSuccessModal") private var shouldShowSuccessModal = false
    @State private var currentTime = Date()
    @State private var showSuccessModal = false
    @State private var selectedTab: MainTab = .counter
    @State private var shareURL: URL?
    @State private var isSharing = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var fadeState: FadeState = .counter
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var timeComponents: TimeComponents {
        if firstBlockDate == 0 {
            return TimeComponents(years: 0, months: 0, days: 0, hours: 0, minutes: 0, seconds: 0)
        }
        let date = Date(timeIntervalSince1970: firstBlockDate)
        return DateHelper.timeComponentsSince(date: date, referenceDate: currentTime)
    }

    private var formattedDate: String {
        if firstBlockDate == 0 {
            return "Not started"
        }
        let date = Date(timeIntervalSince1970: firstBlockDate)
        return DateHelper.formatDate(date: date)
    }

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                CounterTab(
                    timeComponents: timeComponents,
                    formattedDate: formattedDate,
                    fadeState: fadeState
                )
                .environmentObject(profileManager)
                .tag(MainTab.counter)
                .tabItem {
                    Image(systemName: "timer")
                    Text("Counter")
                }

                FriendsTab(
                    referenceDate: currentTime,
                    fadeState: fadeState,
                    onAddFriend: {
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
                    }
                )
                    .environmentObject(profileManager)
                    .tag(MainTab.friends)
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("Friends")
                    }
            }
            .background(Color.appBackground.ignoresSafeArea())
        }
        .background(Color.appBackground.ignoresSafeArea())
        .sheet(isPresented: $showSuccessModal) {
            SuccessModal(manager: manager, isPresented: $showSuccessModal)
        }
        .sheet(isPresented: $isSharing) {
            if let shareURL {
                ShareSheet(items: [shareURL])
            }
        }
        .alert("Something went wrong", isPresented: $showError, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(errorMessage)
        })
        .onReceive(timer) { _ in
            currentTime = Date()
        }
        .onAppear {
            manager.updateAuthorizationStatus()

            if manager.isAuthorized && isBlocking {
                manager.blockApps()
            }

            if shouldShowSuccessModal {
                showSuccessModal = true
                shouldShowSuccessModal = false
            }
        }
        .onChange(of: selectedTab) { _, newValue in
            if newValue == .friends {
                Task { await profileManager.fetchFriends() }
            } else {
            }
            withAnimation(.easeInOut(duration: 0.25)) {
                fadeState = newValue == .friends ? .friends : .counter
            }
        }
        .onChange(of: profileManager.lastErrorMessage) { _, message in
            if let message {
                errorMessage = message
                showError = true
                profileManager.lastErrorMessage = nil
            }
        }
        .onChange(of: showSuccessModal) { newValue in
            if !newValue {
                shouldShowSuccessModal = false
            }
        }
    }
}

private enum MainTab: Hashable {
    case counter
    case friends
}

private enum FadeState {
    case counter
    case friends
}
private struct MainHeader: View {
    var body: some View {
        HStack {
            Image("FadeLogo")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(height: 40)
                .padding(.leading, 20)
                .padding(.top, 8)

            Spacer()

            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primaryBrand)
                    .frame(width: 44, height: 44)
                    .background(Color.surface)
                    .clipShape(Circle())
            }
            .padding(.trailing, 20)
            .padding(.top, 8)
        }
    }
}

private struct CounterTab: View {
    let timeComponents: TimeComponents
    let formattedDate: String
    let fadeState: FadeState

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                MainHeader()

                Spacer()

                VStack(spacing: 20) {
                    HoloCardView {
                        VStack(spacing: 24) {
                            HStack(spacing: 20) {
                                CounterCell(value: timeComponents.years, label: "Y")
                                CounterCell(value: timeComponents.months, label: "M")
                            }
                            HStack(spacing: 20) {
                                CounterCell(value: timeComponents.days, label: "D")
                                CounterCell(value: timeComponents.hours, label: "H")
                            }
                            HStack(spacing: 20) {
                                CounterCell(value: timeComponents.minutes, label: "M")
                                CounterCell(value: timeComponents.seconds, label: "S")
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .opacity(fadeState == .counter ? 1 : 0)
                    .animation(.easeInOut(duration: 0.25), value: fadeState)

                    Text("free since \(formattedDate)")
                        .font(.ibmPlexMono(size: 12, weight: .medium))
                        .foregroundColor(.textSubtle)
                }

                Spacer()
            }
        }
    }
}

private struct FriendsTab: View {
    @EnvironmentObject private var profileManager: ProfileManager
    let referenceDate: Date
    let fadeState: FadeState
    let onAddFriend: () -> Void

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                MainHeader()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        FriendsListView(
                            friends: profileManager.friends,
                            referenceDate: referenceDate,
                            onAddFriend: onAddFriend
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                }
                .opacity(fadeState == .friends ? 1 : 0)
                .animation(.easeInOut(duration: 0.25), value: fadeState)
            }
        }
    }
}

// MARK: - Counter cell (two digits + label)

private struct CounterCell: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(String(format: "%02d", value))
                .font(.joshThick(size: 48))
                .foregroundColor(.primaryBrand.opacity(0.9))
            Text(label)
                .font(.ibmPlexMono(size: 12))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MainView()
}
