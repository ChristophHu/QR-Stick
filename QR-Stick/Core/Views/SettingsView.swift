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
    
    var body: some View {
        newSettingsView
        .infinityFrame()
        .background(Color.appTheme.viewBackground)
    }
}

private extension SettingsView {
    var newSettingsView: some View {
        NavigationStack {
            List {
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
        }
        .infinityFrame()
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
