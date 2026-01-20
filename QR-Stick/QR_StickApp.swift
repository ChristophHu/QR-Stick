//
//  QR_StickApp.swift
//  QR-Stick
//
//  Created by Christoph Huschenhöfer on 20.01.26.
//

import SwiftUI

@main
struct QR_StickApp: App {
    @AppStorage(UserDefaultKeys.isDarkMode) private var isDarkMode: Bool = true

    var body: some Scene {
        WindowGroup {
            AppStartingView()
                .preferredColorScheme(isDarkMode ? .dark : .light)

        }
    }
}
