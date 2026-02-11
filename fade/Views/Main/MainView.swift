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
    @AppStorage("firstBlockDate") private var firstBlockDate: Double = 0
    @AppStorage("isBlocking") private var isBlocking = false
    @AppStorage("shouldShowSuccessModal") private var shouldShowSuccessModal = false
    @State private var currentTime = Date()
    @State private var showSuccessModal = false
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

                    // Counter: 3×2 grid (3 rows, 2 columns)
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            // Row 1: Y, M
                            HStack(spacing: 10) {
                                CounterCell(value: timeComponents.years, label: "Y")
                                CounterCell(value: timeComponents.months, label: "M")
                            }
                            // Row 2: D, H
                            HStack(spacing: 16) {
                                CounterCell(value: timeComponents.days, label: "D")
                                CounterCell(value: timeComponents.hours, label: "H")
                            }
                            // Row 3: M, S
                            HStack(spacing: 16) {
                                CounterCell(value: timeComponents.minutes, label: "M")
                                CounterCell(value: timeComponents.seconds, label: "S")
                            }
                        }

                        Text("free since \(formattedDate)")
                            .font(.ibmPlexMono(size: 12, weight: .medium))
                            .foregroundColor(.primaryBrand.opacity(0.6))
                    }
                    .padding(.horizontal, 20)

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
            manager.updateAuthorizationStatus()

            if manager.isAuthorized && isBlocking {
                manager.blockApps()
            }

            if shouldShowSuccessModal {
                showSuccessModal = true
                shouldShowSuccessModal = false
            }
        }
        .onChange(of: showSuccessModal) { newValue in
            if !newValue {
                shouldShowSuccessModal = false
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
                .foregroundColor(.primaryBrand)
            Text(label)
                .font(.ibmPlexMono(size: 12))
                .foregroundColor(.primaryBrand.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MainView()
}
