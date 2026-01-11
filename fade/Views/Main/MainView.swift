//
//  MainView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI
import Combine

struct MainView: View {
    @StateObject private var manager = ScreenTimeManager.shared
    @AppStorage("firstBlockDate") private var firstBlockDate: Double = 0
    @AppStorage("isBlocking") private var isBlocking = false
    @State private var currentTime = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var timeComponents: TimeComponents {
        if firstBlockDate == 0 {
            return TimeComponents(weeks: 0, days: 0, minutes: 0, seconds: 0)
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
            ZStack {
                Color.appBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Settings button with liquid glass effect
                    HStack {
                        Spacer()
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.primaryBrand)
                                .frame(width: 44, height: 44)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 8)
                    }

                    Spacer()

                    // Counter display
                    VStack(spacing: 30) {
                        // Weeks
                        VStack(spacing: 8) {
                            Text("\(timeComponents.weeks)")
                                .font(.joshFont(size: 72))
                                .foregroundColor(.primaryBrand)
                            Text("weeks")
                                .font(.ibmPlexMono(size: 18))
                                .foregroundColor(.primaryBrand.opacity(0.7))
                        }

                        // Days
                        VStack(spacing: 8) {
                            Text("\(timeComponents.days)")
                                .font(.joshFont(size: 72))
                                .foregroundColor(.primaryBrand)
                            Text("days")
                                .font(.ibmPlexMono(size: 18))
                                .foregroundColor(.primaryBrand.opacity(0.7))
                        }

                        // Minutes
                        VStack(spacing: 8) {
                            Text("\(timeComponents.minutes)")
                                .font(.joshFont(size: 72))
                                .foregroundColor(.primaryBrand)
                            Text("mins")
                                .font(.ibmPlexMono(size: 18))
                                .foregroundColor(.primaryBrand.opacity(0.7))
                        }

                        // Seconds
                        VStack(spacing: 8) {
                            Text("\(timeComponents.seconds)")
                                .font(.joshFont(size: 72))
                                .foregroundColor(.primaryBrand)
                            Text("sec")
                                .font(.ibmPlexMono(size: 18))
                                .foregroundColor(.primaryBrand.opacity(0.7))
                        }

                        // Date
                        Text("free since \(formattedDate)")
                            .font(.ibmPlexMono(size: 14, weight: .semibold))
                            .foregroundColor(.primaryBrand.opacity(0.6))
                            .padding(.top, 16)
                    }

                    Spacer()
                }
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .onReceive(timer) { _ in
            currentTime = Date()
        }
        .onAppear {
            // Update authorization status
            manager.updateAuthorizationStatus()
            
            // Re-apply blocks if they were on when app closed
            if manager.isAuthorized && isBlocking {
                manager.blockApps()
            }
        }
    }
}

#Preview {
    MainView()
}
