//
//  ThemeModel.swift
//  QR-Stick
//
//  Created by Christoph Huschenhöfer on 29.01.26.
//

import SwiftUI
import Combine

final class ThemeSettings: ObservableObject {
    @Published var themeSettings: Int {
        didSet {
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
        }
    }

    init() {
        self.themeSettings = UserDefaults.standard.integer(forKey: "Theme")
    }
}
