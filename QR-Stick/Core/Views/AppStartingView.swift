//
//  AppStartingView.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 08.12.25.
//

import SwiftUI

struct AppStartingView: View {
    /*
     @StateObject tells SwiftUI that the view owns and should create a single instance of an ObservableObject and keep it alive for the view’s lifetime. Initialize it in the view that creates the view model. Use @ObservedObject for objects owned elsewhere. @StateObject prevents the object from being recreated on view updates.
     */
    @StateObject private var viewModel = AppStartingViewModel()
    
    var body: some View {
        /*
         Group is a layout‑neutral SwiftUI container that lets you combine multiple child views into a single view‑builder expression without changing layout. Use it to:
            -   return multiple views from an if/else or closure where a single view is expected,
            -   apply a modifier to several views at once,
            -   avoid adding extra layout containers (no automatic stacking)
         */
        Group {
            if viewModel.shouldShowWelcomeView {
                WelcomeView(isShownWelcomeScreen: $viewModel.shouldShowWelcomeView)
            } else {
                HomeTabView()
            }
        }
        .animation(.easeIn, value: viewModel.shouldShowWelcomeView)
    }
}

#Preview {
    AppStartingView()
}
