//
//  BoxView.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 09.12.25.
//

import SwiftUI

struct BoxView<Content: View>: View {
    let data: Data
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: 8) {
            heading
            divider
            content
        }
        .padding()
        .background(Color.appTheme.cellBackground)
        .cornerRadius(.cell)
    }
}

private extension BoxView {
    var heading: some View {
        HStack {
            Text(data.title)
                .fontWeight(.semibold)
            Spacer()
            if let sfSymbol = data.sfSymbol {
                Image(systemName: sfSymbol)
            }
        }
        .foregroundColor(Color.appTheme.text)
    }
    
    var divider: some View {
        Divider()
            .foregroundColor(Color.appTheme.divider)
    }
}
     
extension BoxView {
    struct Data {
        let title: String
        var sfSymbol: String? = nil
    }
}

#Preview {
    BoxView(data: .init(title: "Developer", sfSymbol: "person.crop.circle")) {
        HStack(spacing: 4) {
            Text("Tel.")
            Spacer()
            Text("030 47749883")
        }
    }
    .padding()
    .infinityFrame()
    .background(Color.appTheme.viewBackground)
}
