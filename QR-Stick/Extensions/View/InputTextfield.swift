//
//  InputTextfield.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 09.12.25.
//

import SwiftUI

extension View {
    func inputTextfield() -> some View {
        self
            .keyboardType(.decimalPad)
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(Color.appTheme.cellBackground)
            .cornerRadius(.textfield)
            .shadow(.regular)
    }
}
