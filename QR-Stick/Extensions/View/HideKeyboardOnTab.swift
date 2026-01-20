//
//  HideKeyboardOnTab.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 09.12.25.
//

import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        self
            .onTapGesture {
                hideKeyboard()
            }
    }
}
