//
//  MotionManager.swift
//  fade
//
//  Created by Josh Mayer on 2/13/26.
//

import CoreMotion
import Foundation

final class MotionManager: ObservableObject {
    @Published private(set) var tiltX: Double = 0
    @Published private(set) var tiltY: Double = 0

    private let manager = CMMotionManager()
    private let smoothingFactor = 0.15
    private var smoothedX: Double = 0
    private var smoothedY: Double = 0

    func start() {
        guard manager.isDeviceMotionAvailable else { return }
        manager.deviceMotionUpdateInterval = 1.0 / 60.0
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self, let motion else { return }
            let rawX = Self.clamp(-motion.attitude.pitch * 20.0, min: -10.0, max: 10.0)
            let rawY = Self.clamp(motion.attitude.roll * 20.0, min: -10.0, max: 10.0)

            smoothedX = (smoothedX * (1 - smoothingFactor)) + (rawX * smoothingFactor)
            smoothedY = (smoothedY * (1 - smoothingFactor)) + (rawY * smoothingFactor)

            tiltX = smoothedX
            tiltY = smoothedY
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
    }

    private static func clamp(_ value: Double, min minValue: Double, max maxValue: Double) -> Double {
        Swift.min(Swift.max(value, minValue), maxValue)
    }
}
