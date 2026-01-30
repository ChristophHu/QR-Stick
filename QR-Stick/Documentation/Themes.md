# Themes

Themes werden im Ordner `Core/Domain/Themes/` gespeichert. Dort finden wir das `themeModel` , die `themeData` und die `ThemeSettings`.

Zur Nutzung von Themes muss in jeder View das Observable angegeben werden. Jede Farbe kann dann die `themes[self.theme.themeSettings].themeColor` aufnehmen.

```swift
struct SettingsView: View {
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings()
    ...
    NavigationStack {
        ...
    } //: NAVIGATION END
    .accentColor(themes[self.theme.themeSettings].themeColor)
}
```

## ThemeModel

Das `Theme` beschreibt die Struktur.

```swift
import SwiftUI

// MARK: - ThemeModel
struct Theme: Identifiable {
    let id: Int
    let themeName: String
    let themeColor: Color
}
```

## ThemeData

In der Datei `Domain/Themes/themeData.swift` werden die Themes mit ID, Namen und Farbe gespeichert.

```swift
import SwiftUI

// MARK: - ThemeData
let themeData: [Theme] = [
    Theme(id: 0, themeName: "Blue", themeColor: Color.blue),
    Theme(id: 1, themeName: "Green", themeColor: Color.green),
    Theme(id: 2, themeName: "Orange", themeColor: Color.orange)
]
```

## ThemeSettings

Die ThemeSettings speichert das Observable und veröffentlicht diese.

```swift
import SwiftUI
import Combine

final class ThemeSettings: ObservableObject {
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
        }
    }

    private init() {}
    public static let shared = ThemeSettings()
}
```

## `SettingsView.swift`

```swift
import SwiftUI
internal import System

struct SettingsView: View {
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared

    var body: some View {
        NavigationStack {
            List {
                // MARK: - SECTION 2
                Section(header:
                    HStack {
                        Text("Choose the app theme")
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(themes[self.theme.themeSettings].themeColor)
                    }
                 ) {
                    //List {
                        ForEach(themes, id: \.id) { item in
                            Button(action: {
                                self.theme.themeSettings = item.id
                                UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                            }) {
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(item.themeColor)
                                        
                                    Text(item.themeName)
                                }
                            } //: Button
                            .accentColor(Color.primary)
                        }
                    //}
                } //: SECTION 2
                .padding(.vertical, 12)
            }
        }
    }
}
```
