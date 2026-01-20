//
//  WelcomeViewModel.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 08.12.25.
//

import Foundation
import Combine

/*
 @MainActor marks that the annotated declaration runs on the main actor (the main thread). It ensures all isolated members execute on the main thread, preventing data races and making it safe to update UI or @Published properties from that type. Calls from background tasks may require switching to the main actor (e.g., await MainActor.run { ... } or Task { @MainActor in ... }).
 */
@MainActor
final class WelcomeViewModel: ObservableObject {
    /*
     this function simulates fetching the app name from a data store or configuration.
     */
    func getAppName() -> String {
        "testApp"
    }
}
