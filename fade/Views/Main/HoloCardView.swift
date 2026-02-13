//
//  HoloCardView.swift
//  fade
//
//  Created by Josh Mayer on 2/13/26.
//

import SwiftUI

struct HoloCardView<Content: View>: View {
    @StateObject private var motion = MotionManager()
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.9),
                            Color.white.opacity(0.6),
                            Color(red: 0.90, green: 0.93, blue: 0.98)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    AngularGradient(
                        colors: [
                            Color(red: 0.65, green: 0.95, blue: 0.95),
                            Color(red: 0.93, green: 0.78, blue: 0.98),
                            Color(red: 0.99, green: 0.92, blue: 0.72),
                            Color(red: 0.65, green: 0.95, blue: 0.95)
                        ],
                        center: .center
                    )
                )
                .blendMode(.screen)
                .opacity(0.35)

            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.9),
                            Color.white.opacity(0.15),
                            Color.clear
                        ],
                        center: UnitPoint(
                            x: Self.clamp01(0.5 + (motion.tiltY / 20.0)),
                            y: Self.clamp01(0.5 + (motion.tiltX / 20.0))
                        ),
                        startRadius: 0,
                        endRadius: 220
                    )
                )
                .blendMode(.screen)
                .opacity(0.5)

            content
                .padding(24)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .rotation3DEffect(.degrees(motion.tiltX), axis: (x: 1, y: 0, z: 0))
        .rotation3DEffect(.degrees(motion.tiltY), axis: (x: 0, y: 1, z: 0))
        .shadow(color: Color.black.opacity(0.18), radius: 22, x: 0, y: 14)
        .onAppear {
            motion.start()
        }
        .onDisappear {
            motion.stop()
        }
    }

    private static func clamp01(_ value: Double) -> Double {
        Swift.min(Swift.max(value, 0.0), 1.0)
    }
}
