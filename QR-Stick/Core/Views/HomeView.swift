//
//  HomeView.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 08.12.25.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingProfile = false
    @State private var isShowingSettings = false
    
    var body: some View {
        NavigationStack {
            Text("HomeView Content")
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            // action
                            isShowingProfile.toggle()
                        } label: {
                            Image(systemName: "person.circle")
                        }
                        .sheet(isPresented: $isShowingProfile) {
                            NavigationStack {
                                ProfileView()
                            }
                        }
                    }
                    // add a button on the right side of the navigation bar
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            // action
                            isShowingSettings.toggle()
                        } label: {
                            Image(systemName: "gearshape")
                        }
                        .sheet(isPresented: $isShowingSettings) {
                            NavigationStack {
                                SettingsView()
                            }
                        }
                    }
                }
        }
    }
}

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        //NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Image("hello")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 80)
                }
                Text("iOS TestApp")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.appTheme.accent)
                Text("Version 1.0.0")
                    .font(.footnote)
                    .foregroundColor(Color.appTheme.text)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.appTheme.cellBackground)
            .cornerRadius(.cell)
            .padding(.horizontal, 8)
            
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                    }
                }
            }
            Spacer()
        //}
    }
}

#Preview {
    HomeView()
}
