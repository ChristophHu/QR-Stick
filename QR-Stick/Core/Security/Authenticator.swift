//
//  Authenticator.swift
//  QR-Stick
//
//  Created by Christoph Huschenhöfer on 22.01.26.
//

import LocalAuthentication
import Foundation

final class BiometryAuthenticator {
    static func isBiometryAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    func authenticate(reason: String = "Unlock the app", completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false, error)
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evalError in
            completion(success, evalError)
        }
    }
}
