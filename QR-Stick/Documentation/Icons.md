# App-Icons

## App-Icons hinzufügen
Unter Assets muss ein Ordner mit dem Namen `AppIcons` erstellt werden. Durch einen rechts-Klick auf den Ordner kann über `iOS/new iOS App Icon` ein neues App Icon hinzugefügt werden.

Icons können dann einfach per Drag-n-Drop in die jeweiligen Felder gezogen werden. Dabei ist darauf zu achten, dass jedes Icon einen eigenen Namen hat. Standardmäßig sind die Icons mit `AppIcon-...` benannt.
Die Icons selbst sollten eine Größe von 1024x1024px haben.

## App-Icon Previews
Es ist ein neuer Ordner `AppIconPreviews` unter `Assets` zu erstellen. In diesem Ordner sind verschiedene Vorschauen für die App Icons zu hinterlegen.

## `SettingsView`
Die AppIcons erhalten einen eigenen Bereich in den Einstellungen, damit der Nutzer das App Icon auswählen kann. Dabei soll jeweils das Preview des Icons angezeigt werden.

```swift
struct SettingsView: View {    
    private let alternateAppIcons: [String] = [
        "AppIcon-Backpack",
        "AppIcon-Camera",
        "AppIcon-Campfire",
        "AppIcon-Glass",
        "AppIcon-Map",
        "AppIcon-Mushroom"
    ]
    ...
    NavigationStack {
        List {
            Section(header: Text("Icons")) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(alternateAppIcons.indices, id: \.self) { item in
                            Button {
                                UIApplication.shared.setAlternateIconName(alternateAppIcons[item]) { error in
                                    if error != nil {
                                        print("Error setting alternate icon: \(String(describing: error?.localizedDescription))")
                                    } else {
                                        print("Successfully changed icon to \(alternateAppIcons[item])")
                                    }
                                }
                            } label: {
                                Image("\(alternateAppIcons[item])-Preview")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(16)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
                .padding(.top, 12)
                Text("Wähle dein bevorzugtes App-Symbol aus der Liste unten aus.")
                    .infinityFrame()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .font(.footnote)
                    .padding(.bottom, 12)
                
            } //: Section
            .listRowSeparator(.hidden)
        } //: List
    }
    ...
}
```

## App-Einstellung
In der Grundeinstellung der App unter `General/AppIcons and Launch Screen` muss die Einstellung für die App Icons vorgenommen werden:
```json
{
    "App Icons Source": true
}
```

