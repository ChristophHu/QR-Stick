//
//  HomeView.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 08.12.25.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        TabView {
            homeTabItemView
            settingsTabItemView
        }
    }
}

private extension HomeTabView {
    var homeTabItemView: some View {
        NavigationStack {
            HomeView()
        }
        .tabItem {
            Image(systemName: "house")
            Text("Home")
        }
    }

    var settingsTabItemView: some View {
        NavigationStack {
            SettingsView()
        }
        .tabItem {
            Image(systemName: "gearshape")
            Text("Settings")
        }
    }
}

#Preview {
    HomeTabView()
}
