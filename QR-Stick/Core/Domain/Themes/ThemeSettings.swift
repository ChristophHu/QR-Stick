//
//  ThemeModel.swift
//  QR-Stick
//
//  Created by Christoph Huschenhöfer on 29.01.26.
//

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
