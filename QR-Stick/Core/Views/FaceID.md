# FaceID

## Build-Einstellungen
Um FaceID in der App zu verwenden, müssen bestimmte Einstellungen im Projekt vorgenommen werden. Es muss die `Info.plist` Datei angepasst werden, um die erforderlichen Berechtigungen zu deklarieren.

### Info.plist
In der `Info.plist` Datei muss der Schlüssel `NSFaceIDUsageDescription` hinzugefügt werden. Dieser Schlüssel enthält eine Beschreibung, die dem Benutzer angezeigt wird, wenn die App um Erlaubnis bittet, FaceID zu verwenden.
```XML
<!-- Info.plist -->
<key>NSFaceIDUsageDescription</key>
<string>Protect your data with Face ID to unlock the app.</string>
```

### Projekt
Ist keine explizite `Info.plist` vorhanden, kann die Einstellung auch über die Xcode-Projekt-Einstellungen `App/Build Settings/Info.plist Values/Privatcy - Face ID Usage Description` vorgenommen werden.
Dort müssen zum Debug oder Release die entsprechenden Texte eingetragen werden.

## Implementierung
### `Authenticator.swift`
Um FaceID in der App zu implementieren, ist es notwendig unter `Core/Security` die Klasse `BiometryAuthenticator` hinzuzufügen.
```swift
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
```

### `Settings.swift`
In der Datei `SettingsView.swift` muss die Option zur Aktivierung von FaceID hinzugefügt werden.
```swift
...
@AppStorage("useFaceID") private var useFaceID: Bool = false
@State private var showAuthError: Bool = false
@State private var authErrorMessage: String = ""
...
NavigationStack {
    List {
        // Neue Security-Section mit Face ID Toggle
        Section(header: Text("Sicherheit")) {
            Toggle("Use Face ID", isOn: $useFaceID)
                .disabled(!BiometryAuthenticator.isBiometryAvailable())
                .tint(Color.appTheme.accent)
                .onChange(of: useFaceID) { _, newValue in
                    if newValue {
                        BiometryAuthenticator().authenticate(reason: "Face ID nutzen") { success, error in
                            DispatchQueue.main.async {
                                if !success {
                                    useFaceID = false
                                    authErrorMessage = error?.localizedDescription ?? "Face ID failed"
                                    showAuthError = true
                                }
                            }
                        }
                    }
                }

            if !BiometryAuthenticator.isBiometryAvailable() {
                Text("Face ID nicht verfügbar")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
    }
}
```

Nach dieser Implementierung kann FaceID verwendet werden. Es fehlt jedoch noch die Logik, um die App beim Start zu sperren und die Authentifizierung durchzuführen, wenn FaceID aktiviert ist.

## Zugriffsschutz
### `AppLockManager.swift`
Um die App beim Start zu sperren und die Authentifizierung durchzuführen, wenn FaceID aktiviert ist, muss ein `AppLockManager` erstellt werden.
Dieses Objekt kontrolliert, ob die App bereits gesperrt ist und führt bei Bedarf eine Authentifizierung durch.
Die Klasse `AppLockManager` ist unter dem Pfad `/Core/Security` zu erstellen.
```swift
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

```

### `LockView.swift`
Um die App beim Start zu sperren und die Authentifizierung durchzuführen, wenn FaceID aktiviert ist, muss eine `LockView` erstellt werden.

```swift
import SwiftUI

struct LockView: View {
    @ObservedObject var lockManager: AppLockManager

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: "faceid")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 84, height: 84)
                    .foregroundColor(.accentColor)

                Text("Protected by Face ID")
                    .font(.title3)
                    .multilineTextAlignment(.center)

                Button(action: { lockManager.authenticate() }) {
                    Text("Unlock")
                        .bold()
                        .frame(minWidth: 140)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .accessibilityAddTraits(.isModal)
    }
}
```

In der `TestApp.swift` ist der AppLockManager zu initialisieren und die `LockView` anzuzeigen, wenn die App gesperrt ist.

```swift
import SwiftUI

@main
struct TestApp: App {
    @StateObject private var lockManager = AppLockManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear { lockManager.checkOnLaunch() }
                .overlay {
                    if lockManager.isLocked {
                        LockView(lockManager: lockManager)
                            .transition(.opacity)
                            .zIndex(1)
                    }
                }
                .environmentObject(lockManager)
        }
    }
}
```
