//
//  HoloCardView.swift
//  fade
//
//  Created by Josh Mayer on 2/13/26.
//

import SwiftUI

struct HoloCardView<Content: View>: View {
    @StateObject private var motion = MotionManager()
    @State private var touchTiltX: Double = 0
    @State private var touchTiltY: Double = 0
    private let content: Content
    private let height: CGFloat

    init(height: CGFloat = 320, @ViewBuilder content: () -> Content) {
        self.height = height
        self.content = content()
    }

    private var combinedTiltX: Double {
        clamp(motion.tiltX + touchTiltX, min: -12, max: 12)
    }

    private var combinedTiltY: Double {
        clamp(motion.tiltY + touchTiltY, min: -12, max: 12)
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
                .opacity(0.45)

            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.9),
                            Color.white.opacity(0.15),
                            Color.clear
                        ],
                        center: UnitPoint(
                            x: Self.clamp01(0.5 + (combinedTiltY / 20.0)),
                            y: Self.clamp01(0.5 + (combinedTiltX / 20.0))
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
        .frame(maxWidth: 340)
        .frame(height: height)
        .rotation3DEffect(.degrees(combinedTiltX), axis: (x: 1, y: 0, z: 0))
        .rotation3DEffect(.degrees(combinedTiltY), axis: (x: 0, y: 1, z: 0))
        .shadow(color: Color.black.opacity(0.18), radius: 22, x: 0, y: 14)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let x = (value.location.x - 170) / 170
                    let y = (value.location.y - 160) / 160
                    touchTiltY = clamp(Double(x) * 8, min: -8, max: 8)
                    touchTiltX = clamp(Double(-y) * 8, min: -8, max: 8)
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        touchTiltX = 0
                        touchTiltY = 0
                    }
                }
        )
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

    private func clamp(_ value: Double, min minValue: Double, max maxValue: Double) -> Double {
        Swift.min(Swift.max(value, minValue), maxValue)
    }
}
