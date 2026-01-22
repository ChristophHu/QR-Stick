//
//  LockView.swift
//  QR-Stick
//
//  Created by Christoph Huschenhöfer on 22.01.26.
//

import SwiftUI

struct LockView: View {
    @ObservedObject var lockManager: AppLockManager

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: "faceid")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 84, height: 84)
                    .foregroundColor(.accentColor)

                Text("Protected by Face ID")
                    .font(.title3)
                    .multilineTextAlignment(.center)

                Button(action: { lockManager.authenticate() }) {
                    Text("Unlock")
                        .bold()
                        .frame(minWidth: 140)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .accessibilityAddTraits(.isModal)
    }
}
