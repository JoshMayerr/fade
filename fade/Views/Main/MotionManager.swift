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
    private let restBlendFactor = 0.05
    private let stillnessThreshold = 0.35
    private var smoothedX: Double = 0
    private var smoothedY: Double = 0
    private var restPitch: Double = 0
    private var restRoll: Double = 0

    func start() {
        guard manager.isDeviceMotionAvailable else { return }
        manager.deviceMotionUpdateInterval = 1.0 / 60.0
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self, let motion else { return }
            let rotation = motion.rotationRate
            let rotationMagnitude = sqrt(rotation.x * rotation.x + rotation.y * rotation.y + rotation.z * rotation.z)

            if rotationMagnitude < stillnessThreshold {
                restPitch = (restPitch * (1 - restBlendFactor)) + (motion.attitude.pitch * restBlendFactor)
                restRoll = (restRoll * (1 - restBlendFactor)) + (motion.attitude.roll * restBlendFactor)
            }

            let pitch = motion.attitude.pitch - restPitch
            let roll = motion.attitude.roll - restRoll

            let rawX = Self.clamp(-pitch * 20.0, min: -10.0, max: 10.0)
            let rawY = Self.clamp(roll * 20.0, min: -10.0, max: 10.0)

            smoothedX = (smoothedX * (1 - smoothingFactor)) + (rawX * smoothingFactor)
            smoothedY = (smoothedY * (1 - smoothingFactor)) + (rawY * smoothingFactor)

            tiltX = smoothedX
            tiltY = smoothedY
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
    }

    func resetRestAngle() {
        restPitch = 0
        restRoll = 0
    }

    private static func clamp(_ value: Double, min minValue: Double, max maxValue: Double) -> Double {
        Swift.min(Swift.max(value, minValue), maxValue)
    }
}
