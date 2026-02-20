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
                    fadeState: fadeState,
                    firstBlockDate: firstBlockDate,
                    currentTime: currentTime
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
    let firstBlockDate: Double
    let currentTime: Date

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            GardenBackgroundView(
                firstBlockDate: firstBlockDate,
                currentTime: currentTime
            )

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

// MARK: - Garden Background

private struct GardenBackgroundView: View {
    let firstBlockDate: Double
    let currentTime: Date

    private var elapsedSeconds: TimeInterval {
        guard firstBlockDate > 0 else { return 0 }
        let start = Date(timeIntervalSince1970: firstBlockDate)
        return max(0, currentTime.timeIntervalSince(start))
    }

    var body: some View {
        GeometryReader { proxy in
            let elements = GardenElementBuilder.elements(
                elapsedSeconds: elapsedSeconds,
                seed: UInt64(firstBlockDate)
            )
            ZStack {
                ForEach(elements) { element in
                    GardenElementView(
                        element: element,
                        time: currentTime,
                        size: proxy.size
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .allowsHitTesting(false)
        .opacity(firstBlockDate == 0 ? 0 : 1)
        .animation(.easeInOut(duration: 0.4), value: firstBlockDate)
    }
}

private enum GardenElementKind: String {
    case seed
    case sprout
    case leaf
    case stem
    case flower
    case glow
}

private struct GardenElement: Identifiable {
    let id: String
    let kind: GardenElementKind
    let position: CGPoint // normalized 0...1
    let size: CGFloat
    let opacity: CGFloat
    let rotation: Angle
    let phase: Double
}

private struct GardenElementBuilder {
    static func elements(elapsedSeconds: TimeInterval, seed: UInt64) -> [GardenElement] {
        guard elapsedSeconds > 0 else { return [] }

        var rng = SeededGenerator(seed: seed == 0 ? 1 : seed)
        var items: [GardenElement] = []
        let maxElements = 320

        let elapsedHours = Int(elapsedSeconds / 3600)
        let elapsedDays = Int(elapsedSeconds / 86400)
        let elapsedYears = max(0, elapsedDays / 365)

        // Continuous seeds
        let seedCount = min(elapsedHours, 180)
        items.append(contentsOf: makeElements(
            count: seedCount,
            kind: .seed,
            idPrefix: "seed",
            sizeRange: 4...7,
            opacityRange: 0.28...0.4,
            rng: &rng
        ))

        // Milestones
        if elapsedDays >= 1 {
            items.append(contentsOf: makeElements(
                count: 12,
                kind: .sprout,
                idPrefix: "sprout-day",
                sizeRange: 14...22,
                opacityRange: 0.32...0.46,
                rng: &rng
            ))
        }

        if elapsedDays >= 7 {
            items.append(contentsOf: makeElements(
                count: 18,
                kind: .sprout,
                idPrefix: "sprout-week",
                sizeRange: 16...24,
                opacityRange: 0.36...0.52,
                rng: &rng
            ))
        }

        if elapsedDays >= 30 {
            items.append(contentsOf: makeElements(
                count: 14,
                kind: .stem,
                idPrefix: "stem-month",
                sizeRange: 24...36,
                opacityRange: 0.34...0.5,
                rng: &rng
            ))
            items.append(contentsOf: makeElements(
                count: 18,
                kind: .leaf,
                idPrefix: "leaf-month",
                sizeRange: 18...28,
                opacityRange: 0.38...0.56,
                rng: &rng
            ))
        }

        if elapsedDays >= 100 {
            items.append(contentsOf: makeElements(
                count: 20,
                kind: .leaf,
                idPrefix: "leaf-100d",
                sizeRange: 20...30,
                opacityRange: 0.42...0.6,
                rng: &rng
            ))
            items.append(contentsOf: makeElements(
                count: 10,
                kind: .flower,
                idPrefix: "flower-100d",
                sizeRange: 22...34,
                opacityRange: 0.45...0.65,
                rng: &rng
            ))
        }

        if elapsedYears > 0 {
            let yearCount = min(elapsedYears, 10)
            items.append(contentsOf: makeElements(
                count: yearCount * 2,
                kind: .flower,
                idPrefix: "flower-year",
                sizeRange: 34...48,
                opacityRange: 0.55...0.75,
                rng: &rng
            ))
            items.append(contentsOf: makeElements(
                count: yearCount * 2,
                kind: .glow,
                idPrefix: "glow-year",
                sizeRange: 64...84,
                opacityRange: 0.28...0.4,
                rng: &rng
            ))
        }

        if items.count > maxElements {
            items = Array(items.prefix(maxElements))
        }

        return items
    }

    private static func makeElements(
        count: Int,
        kind: GardenElementKind,
        idPrefix: String,
        sizeRange: ClosedRange<CGFloat>,
        opacityRange: ClosedRange<CGFloat>,
        rng: inout SeededGenerator
    ) -> [GardenElement] {
        guard count > 0 else { return [] }

        var results: [GardenElement] = []
        results.reserveCapacity(count)

        for i in 0..<count {
            let position = randomPosition(rng: &rng)
            let size = CGFloat.random(in: sizeRange, using: &rng)
            let opacity = CGFloat.random(in: opacityRange, using: &rng)
            let rotation = Angle.degrees(Double.random(in: -20...20, using: &rng))
            let phase = Double.random(in: 0...Double.pi * 2, using: &rng)

            results.append(
                GardenElement(
                    id: "\(idPrefix)-\(i)-\(Int(size))",
                    kind: kind,
                    position: position,
                    size: size,
                    opacity: opacity,
                    rotation: rotation,
                    phase: phase
                )
            )
        }

        return results
    }

    private static func randomPosition(rng: inout SeededGenerator) -> CGPoint {
        // Avoid the center to keep the counter readable.
        for _ in 0..<8 {
            let x = CGFloat.random(in: 0.06...0.94, using: &rng)
            let y = CGFloat.random(in: 0.06...0.94, using: &rng)
            if x < 0.3 || x > 0.7 || y < 0.3 || y > 0.7 {
                return CGPoint(x: x, y: y)
            }
        }
        return CGPoint(x: 0.1, y: 0.1)
    }
}

private struct GardenElementView: View {
    let element: GardenElement
    let time: Date
    let size: CGSize

    private var baseColor: Color {
        switch element.kind {
        case .seed:
            return .primaryBrand.opacity(0.55)
        case .sprout, .leaf, .stem:
            return .success.opacity(0.75)
        case .flower:
            return .accentBrand.opacity(0.9)
        case .glow:
            return .accentBrand.opacity(0.6)
        }
    }

    private var pulseOpacity: CGFloat {
        let t = time.timeIntervalSince1970
        let pulse = 0.12 * sin(t + element.phase)
        return max(0.12, element.opacity + CGFloat(pulse))
    }

    var body: some View {
        let position = CGPoint(
            x: element.position.x * size.width,
            y: element.position.y * size.height
        )

        Group {
            switch element.kind {
            case .seed:
                Circle()
                    .fill(baseColor)
                    .frame(width: element.size, height: element.size)
            case .stem:
                RoundedRectangle(cornerRadius: element.size / 4)
                    .fill(baseColor)
                    .frame(width: max(2, element.size / 6), height: element.size)
            case .sprout, .leaf:
                Image(systemName: "leaf.fill")
                    .font(.system(size: element.size, weight: .regular))
                    .foregroundColor(baseColor)
            case .flower:
                Image(systemName: "flower")
                    .font(.system(size: element.size, weight: .regular))
                    .foregroundColor(baseColor)
            case .glow:
                Circle()
                    .stroke(baseColor, lineWidth: 1.5)
                    .frame(width: element.size, height: element.size)
                    .blur(radius: 2)
            }
        }
        .rotationEffect(element.rotation)
        .position(position)
        .opacity(pulseOpacity)
        .animation(.easeInOut(duration: 3.0), value: time)
    }
}

private struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed &+ 0x9E3779B97F4A7C15
    }

    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
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
        .environmentObject(ProfileManager())
}

#Preview("Garden Test - 400 days") {
    CounterTab(
        timeComponents: TimeComponents(years: 1, months: 1, days: 5, hours: 0, minutes: 0, seconds: 0),
        formattedDate: "Jan 15, 2025",
        fadeState: .counter,
        firstBlockDate: Date().addingTimeInterval(-400 * 86400).timeIntervalSince1970,
        currentTime: Date()
    )
}
