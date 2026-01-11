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
    @AppStorage("shouldShowSuccessModal") private var shouldShowSuccessModal = false
    @State private var currentTime = Date()
    @State private var showSuccessModal = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var timeComponents: TimeComponents {
        if firstBlockDate == 0 {
            return TimeComponents(weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0)
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
                    // Logo and settings button
                    HStack {
                        Image("FadeLogo")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.accentBrand)
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
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 8)
                    }

                    Spacer()

                    // Counter display
                    HStack {
                        VStack(alignment: .leading, spacing: 30) {
                            // Weeks
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(String(format: "%02d", timeComponents.weeks))
                                    .font(.joshFont(size: 56))
                                    .foregroundColor(.primaryBrand)
                                Text("W")
                                    .font(.ibmPlexMono(size: 14))
                                    .foregroundColor(.primaryBrand.opacity(0.7))
                            }

                            // Days
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(String(format: "%02d", timeComponents.days))
                                    .font(.joshFont(size: 56))
                                    .foregroundColor(.primaryBrand)
                                Text("D")
                                    .font(.ibmPlexMono(size: 14))
                                    .foregroundColor(.primaryBrand.opacity(0.7))
                            }

                            // Hours
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(String(format: "%02d", timeComponents.hours))
                                    .font(.joshFont(size: 56))
                                    .foregroundColor(.primaryBrand)
                                Text("H")
                                    .font(.ibmPlexMono(size: 14))
                                    .foregroundColor(.primaryBrand.opacity(0.7))
                            }

                            // Minutes
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(String(format: "%02d", timeComponents.minutes))
                                    .font(.joshFont(size: 56))
                                    .foregroundColor(.primaryBrand)
                                Text("M")
                                    .font(.ibmPlexMono(size: 14))
                                    .foregroundColor(.primaryBrand.opacity(0.7))
                            }

                            // Seconds
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(String(format: "%02d", timeComponents.seconds))
                                    .font(.joshFont(size: 56))
                                    .foregroundColor(.primaryBrand)
                                Text("S")
                                    .font(.ibmPlexMono(size: 14))
                                    .foregroundColor(.primaryBrand.opacity(0.7))
                            }

                            // Date
                            Text("free since \(formattedDate)")
                                .font(.ibmPlexMono(size: 14, weight: .semibold))
                                .foregroundColor(.primaryBrand.opacity(0.6))
                                .padding(.top, 16)
                        }
                        .padding(.leading, 20)

                        Spacer()
                    }

                    Spacer()
                }
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .sheet(isPresented: $showSuccessModal) {
            SuccessModal(manager: manager, isPresented: $showSuccessModal)
        }
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
            
            // Show success modal if flag is set
            if shouldShowSuccessModal {
                showSuccessModal = true
                shouldShowSuccessModal = false
            }
        }
        .onChange(of: showSuccessModal) { newValue in
            // Clear the flag when modal is dismissed
            if !newValue {
                shouldShowSuccessModal = false
            }
        }
    }
}

#Preview {
    MainView()
}
