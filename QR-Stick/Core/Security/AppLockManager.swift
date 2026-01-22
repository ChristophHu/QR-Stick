//
//  AppLockManager.swift
//  QR-Stick
//
//  Created by Christoph Huschenhöfer on 22.01.26.
//

import Foundation
import LocalAuthentication
import SwiftUI
import Combine

@MainActor
final class AppLockManager: ObservableObject {
    @AppStorage("useFaceID") private var useFaceID: Bool = false
    @Published var isLocked: Bool = false

    func checkOnLaunch() {
        // Lock only if user enabled Face ID
        isLocked = useFaceID
        if useFaceID {
            authenticate(reason: "Unlock the app")
        }
    }

    func authenticate(reason: String = "Unlock the app", allowPasscode: Bool = true) {
        Task {
            let context = LAContext()
            var error: NSError?
            let policy: LAPolicy = allowPasscode ? .deviceOwnerAuthentication : .deviceOwnerAuthenticationWithBiometrics

            // If policy can't be evaluated, unlock to avoid blocking the user
            guard context.canEvaluatePolicy(policy, error: &error) else {
                await MainActor.run { self.isLocked = false }
                return
            }

            let result = await withCheckedContinuation { (continuation: CheckedContinuation<(Bool, Error?), Never>) in
                context.evaluatePolicy(policy, localizedReason: reason) { success, evalError in
                    continuation.resume(returning: (success, evalError))
                }
            }

            await MainActor.run {
                self.isLocked = !result.0
            }
        }
    }

    func forceLock() {
        isLocked = useFaceID
    }

    func forceUnlock() {
        isLocked = false
    }
}
