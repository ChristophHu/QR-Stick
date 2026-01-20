//
//  InfinityFrame.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 08.12.25.
//
/*
 infinityFrame() is a small SwiftUI View extension that applies .frame(maxWidth: .infinity, maxHeight: .infinity) to the view. It returns the original view modified to expand to fill all available width and height.
 */

import SwiftUI

extension View {
    func infinityFrame() -> some View {
        /*
         self refers to the current instance (the value or object) inside a type. In your View extension it is the view being modified; calling self.frame(...) applies the modifier to that view and returns the result. You can often omit self unless needed to disambiguate, inside escaping closures (capture), or in mutating methods where you assign to self.
         */
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
