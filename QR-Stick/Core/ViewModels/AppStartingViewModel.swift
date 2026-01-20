//
//  AppSatrtingViewModel.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 08.12.25.
//

import Foundation
/*
 import Combine brings in Apple’s reactive framework for handling asynchronous streams of values. It provides publishers, subscribers, operators, subjects, cancellables and schedulers, plus integrations with Foundation and SwiftUI.
 */
import Combine

/*
 @MainActor marks that the annotated declaration runs on the main actor (the main thread). It ensures all isolated members execute on the main thread, preventing data races and making it safe to update UI or @Published properties from that type. Calls from background tasks may require switching to the main actor (e.g., await MainActor.run { ... } or Task { @MainActor in ... }).
 */
@MainActor
final class AppStartingViewModel: ObservableObject {
    /*
     @Published is a Combine property wrapper used inside an ObservableObject. It automatically emits change notifications when the property changes so SwiftUI views (or other subscribers) can update. Use it with @StateObject / @ObservedObject in views to react to changes.
     */
    @Published var shouldShowWelcomeView: Bool = true
}
