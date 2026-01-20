//
//  HideKeyboard.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 09.12.25.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
