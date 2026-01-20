//
//  Color.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 08.12.25.
//

import SwiftUI

extension Color {
    static var appTheme: AppColorTheme = main
}

extension Color {
    static var main: AppColorTheme {
        .init(
            accent: .init(.accent),
            accentContrastText: .init(.accentContrastText),
            cellBackground: .init(.cellBackground),
            destructive: .init(.destructive),
            divider: .init(.divider),
            text: .init(.text),
            secondaryText: .init(.secondaryText),
            viewBackground: .init(.viewBackground)
        )
    }
}

struct AppColorTheme {
    let accent: Color
    let accentContrastText: Color
    let cellBackground: Color
    let destructive: Color
    let divider: Color
    let text: Color
    let secondaryText: Color
    let viewBackground: Color
}

#Preview("Light Mode") {
    Preview()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    Preview()
        .preferredColorScheme(.dark)
}

fileprivate struct Preview: View {
    var body: some View {
        VStack {
            VStack {
                Text("Title")
                    .foregroundColor(.appTheme.text)
                Text("Subtitle")
                    .foregroundColor(.appTheme.secondaryText)
            }

            Divider()
                .foregroundColor(.appTheme.divider)
                .padding(.horizontal)
            
            Button {} label: {
                Text("Get Started")
                    .padding()
                    .background(Color.appTheme.accent)
                    .cornerRadius(8)
                    .foregroundColor(.appTheme.accentContrastText)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appTheme.viewBackground)
    }
}
