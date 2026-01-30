//
//  SettingsView.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 08.12.25.
//

import SwiftUI
internal import System

struct SettingsView: View {
    @AppStorage(UserDefaultKeys.isDarkMode) private var isDarkMode: Bool = true
    @AppStorage("useFaceID") private var useFaceID: Bool = false
    
    @State private var showAuthError: Bool = false
    @State private var authErrorMessage: String = ""
    
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared
    
    private let alternateAppIcons: [String] = [
        "AppIcon",
        "AppIcon-Wo",
        "AppIcon-Dark",
        "AppIcon-Wo-Dark",
        "AppIcon-Black"
    ]
    
    var body: some View {
        newSettingsView
            .infinityFrame()
            .background(Color.appTheme.viewBackground)
            .alert(authErrorMessage, isPresented: $showAuthError) {
                Button("OK", role: .cancel) { }
            }
    }
}

private extension SettingsView {
    var newSettingsView: some View {
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
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(themes, id: \.id) { item in
                                Button {
                                    withAnimation { theme.themeSettings = item.id }
                                } label: {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(item.themeColor)
                                            .frame(width: 12, height: 12)
                                        Text(item.themeName)
                                            .font(.subheadline)
                                            .lineLimit(1)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(
                                        Group {
                                            if theme.themeSettings == item.id {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(item.themeColor.opacity(0.18))
                                            } else {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.clear)
                                            }
                                        }
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(theme.themeSettings == item.id ? item.themeColor : Color.secondary.opacity(0.25), lineWidth: 1)
                                    )
                                    .foregroundColor(theme.themeSettings == item.id ? item.themeColor : Color.primary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 6)
                    }
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
                .padding(.vertical, 2)
                
                // MARK: - SECTION 3
                Section {
                    NavigationLink {
                        ThemeView(themeMode: isDarkMode ? .constant("Dark") : .constant("Light"))
                    } label: {
                        HStack {
                            Text("Darstellung")
                            Spacer()
                            Text(isDarkMode ? "Dunkel" : "Hell")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    NavigationLink {
                        AccentColorView()
                    } label: {
                        HStack {
                            Text("Accentcolor")
                        }
                    }
                    
                    NavigationLink {
                        IconView()
                    } label: {
                        HStack {
                            Text("App-Symbol")
                            Spacer()
                            Text("iOS")
                                .foregroundColor(.secondary)
                        }
                    }
                } //: SECTION 3
                
                // Neue Security-Section mit Face ID Toggle
                Section(header: Text("Sicherheit")) {
                    Toggle("Use Face ID", isOn: $useFaceID)
                        .disabled(!BiometryAuthenticator.isBiometryAvailable())
                        .tint(Color.appTheme.accent)
                        .onChange(of: useFaceID) { _, newValue in
                            if newValue {
                                BiometryAuthenticator().authenticate(reason: "Use Face ID to protect the app") { success, error in
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
                    
                Section {
                    NavigationLink("Copilot", destination: EmptyView())
                }
                Section {
                    NavigationLink("Benachrichtigungen", destination: EmptyView())
                    NavigationLink("Codeoptionen", destination: EmptyView())
                    NavigationLink("Externe Links", destination: WebViewContainer(urlString: "https://www.apple.com"))
                }
                Section {
                    Button("Send Feedback") { /* action */ }
                    NavigationLink("Help", destination: EmptyView())
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        } //: NAVIGATION END
        .infinityFrame()
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .background(Color.appTheme.viewBackground)
    }
    
    var customizationBoxView: some View {
        BoxView(data: .init(title: "Customization", sfSymbol: "paintbrush")) {
            Toggle("Dark Mode", isOn: $isDarkMode)
                .tint(Color.appTheme.accent)
        }
    }
}

struct ThemeView: View {
    @Binding var themeMode: String
    private let options: [String] = ["Light", "Dark", "System"]
    
    var body: some View {
        List {
            ForEach(options, id: \.self) { option in
                Button {
                    themeMode = option
                } label: {
                    HStack {
                        Text(option)
                        Spacer()
                        if themeMode == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(.appTheme.accent)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .button(.plain) {
                    
                }
            }
        }
        .navigationTitle("Darstellung")
        
    }
}
struct IconView: View {
    var body: some View {
    }
}

struct AccentColorView: View {
    @AppStorage("accentColor") private var accentColorName: String = "blue"

    private let options: [(id: String, color: Color)] = [
        ("blue", .blue),
        ("green", .green),
        ("red", .red),
        ("purple", .purple),
        ("orange", .orange),
    ]

    var body: some View {
        List {
            ForEach(options, id: \.id) { option in
                Button {
                    accentColorName = option.id
                } label: {
                    HStack {
                        Text(option.id.capitalized)
                        Spacer()
                        Circle()
                            .fill(option.color)
                            .frame(width: 22, height: 22)
                        if accentColorName == option.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .padding(.leading, 6)
                                .background(Circle().fill(option.color))
                                .clipShape(Circle())
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Akzentfarbe")
    }
}

struct EmptyView: View {
    var body: some View {
        
    }
}

#Preview {
    SettingsView()
}
